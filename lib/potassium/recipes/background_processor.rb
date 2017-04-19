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
    gather_gem "delayed_job_active_record"

    general_config = "config.active_job.queue_adapter = :delayed_job"
    application(general_config)
    dev_config = "config.active_job.queue_adapter = :inline"
    application dev_config, env: "development"

    after(:gem_install) do
      generate "delayed_job:active_record"
      add_readme_section :internal_dependencies, :delayed_job

      if selected?(:heroku)
        gsub_file("Procfile", /^.*$/m) { |match| "#{match}worker: bundle exec rails jobs:work" }
      end

      file_name = `ls ./db/migrate`.split("\n")
                                   .find { |i| i['create_delayed_jobs.rb'].present? }

      insert_into_file './db/migrate/' + file_name, "[4.2]", after: "ActiveRecord::Migration"
    end
  end

  def add_sidekiq
    puts "TODO: add sidekiq bg processor."
  end
end
