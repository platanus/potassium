class Recipes::BackgroundProcessor < Rails::AppBuilder
  def ask
    response = if selected?(:email_service, :none)
                 answer(:background_processor) do
                   Ask.confirm("Do you want to use Sidekiq for background job processing?")
                 end
               else
                 info "Note: Emails should be sent on background jobs. We'll install sidekiq"
                 true
               end
    set(:background_processor, response)
  end

  def create
    if get(:background_processor)
      add_sidekiq
      add_docker_compose_redis_config
      set_redis_dot_env
    end
  end

  def install
    ask
    heroku = load_recipe(:heroku)
    set(:heroku, heroku.installed?)
    create
  end

  def installed?
    gem_exists?(/sidekiq/)
  end

  private

  def add_docker_compose_redis_config
    compose = DockerHelpers.new('docker-compose.yml')

    service_definition =
      <<~YAML
        image: redis
        ports:
          - 6379
        volumes:
          - redis_data:/data
      YAML

    compose.add_service('redis', service_definition)
    compose.add_volume('redis_data')
  end

  def set_redis_dot_env
    append_to_file(
      '.env.development',
      <<~TEXT
        REDIS_HOST=127.0.0.1
        REDIS_PORT=$(make services-port SERVICE=redis PORT=6379)
        REDIS_URL=redis://${REDIS_HOST}:${REDIS_PORT}/1
      TEXT
    )
  end

  def add_sidekiq
    gather_gem("sidekiq")
    add_adapters("sidekiq")
    add_readme_section :internal_dependencies, :sidekiq
    edit_procfile("bundle exec sidekiq")
    append_to_file(".env.development", "DB_POOL=25\n")
    template("../assets/sidekiq.rb.erb", "config/initializers/sidekiq.rb", force: true)
    copy_file("../assets/sidekiq.yml", "config/sidekiq.yml", force: true)
    copy_file("../assets/redis.yml", "config/redis.yml", force: true)

    insert_into_file "config/routes.rb", after: "Rails.application.routes.draw do\n" do
      <<-HERE.gsub(/^ {6}/, '')
        mount Sidekiq::Web => '/queue'
      HERE
    end
  end

  def edit_procfile(cmd)
    heroku = load_recipe(:heroku)
    if selected?(:heroku) || heroku.installed?
      gsub_file('Procfile', /^.*$/m) { |match| "#{match}worker: #{cmd}" }
    end
  end

  def add_adapters(name)
    application("config.active_job.queue_adapter = :#{name}")
    application "config.active_job.queue_adapter = :async", env: "development"
    application "config.active_job.queue_adapter = :test", env: "test"
  end
end
