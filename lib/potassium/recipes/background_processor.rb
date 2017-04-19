class Recipes::BackgroundProcessor < Rails::AppBuilder
  def ask
    options = {
      sidekiq: "Sidekiq",
      delayed_job: "Delayed Job",
      none: "None, thanks"
    }

    response = answer(:background_processor) do
      options.keys[Ask.list("Which background processor are you using?", options.values)]
    end

    set(:background_processor, response.to_sym)
  end

  def create
    processor = get(:background_processor)
    return if processor == :none
    send("add_#{processor}")
  end

  def install
    ask
    heroku = load_recipe(:heroku)
    set(:heroku, heroku.installed?)
    create
  end

  def installed?
    delayed_job_installed? || sidekiq_installed?
  end

  def delayed_job_installed?
    gem_exists?(/delayed_job_active_record/)
  end

  def sidekiq_installed?
    gem_exists?(/sidekiq/)
  end

  def add_delayed_job
    gather_gem("delayed_job_active_record")
    add_adapters("delayed_job")
    add_readme_section :internal_dependencies, :delayed_job
    recipe = self

    after(:gem_install) do
      generate "delayed_job:active_record"
      recipe.edit_procfile("bundle exec rails jobs:work")
      file_name = `ls ./db/migrate`.split("\n")
                                   .find { |i| i["create_delayed_jobs.rb"].present? }

      insert_into_file "./db/migrate/" + file_name, "[4.2]", after: "ActiveRecord::Migration"
    end
  end

  def add_sidekiq
    gather_gem("sidekiq")
    add_adapters("sidekiq")
    add_readme_section :internal_dependencies, :sidekiq
    edit_procfile("bundle exec sidekiq")
    append_to_file(".env.development", "DB_POOL=25\n")
    copy_file("../assets/sidekiq.rb", "config/initializers/sidekiq.rb", force: true)
    copy_file("../assets/sidekiq.yml", "config/sidekiq.yml", force: true)
    copy_file("../assets/redis.yml", "config/redis.yml", force: true)

    insert_into_file "config/routes.rb", after: "Rails.application.routes.draw do\n" do
      <<-HERE.gsub(/^ {6}/, '')
        mount Sidekiq::Web => '/queue'
      HERE
    end
  end

  def edit_procfile(cmd)
    gsub_file("Procfile", /^.*$/m) { |match| "#{match}worker: #{cmd}" } if selected?(:heroku)
  end

  def add_adapters(name)
    general_config = "config.active_job.queue_adapter = :#{name}"
    application(general_config)
    dev_config = "config.active_job.queue_adapter = :inline"
    application dev_config, env: "development"
  end
end
