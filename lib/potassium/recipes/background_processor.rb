#
# 1. Mail
# if !mail
# 2. Do you want Sidekiq to process background jobs?
# if jobs
# 3. Do you need Sidekiq-Scheduler to schedule background tasks?

class Recipes::BackgroundProcessor < Rails::AppBuilder
  def ask
    install = if selected?(:email_service, :none)
                answer(:background_processor) do
                  Ask.confirm("Do you want to use Sidekiq for background job processing?")
                end
              else
                info "Note: Emails should be sent on background jobs. We'll install sidekiq"
                true
              end
    set(:background_processor, install)
  end

  def create
    add_sidekiq if get(:background_processor)
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
    application("config.active_job.queue_adapter = :#{name}")
    application "config.active_job.queue_adapter = :inline", env: "development"
    application "config.active_job.queue_adapter = :test", env: "test"
  end
end
