class Recipes::DelayedJob < Rails::AppBuilder
  def ask
    use_delayed_job = answer(:"delayed-job") { Ask.confirm("Do you want to use delayed jobs?") }
    set(:delayed_job, use_delayed_job)
  end

  def create
    add_delayed_job if selected?(:delayed_job)
  end

  def install
    heroku = load_recipe(:heroku)
    set(:heroku, heroku.installed?)
    add_delayed_job
  end

  def installed?
    gem_exists?(/delayed_job_active_record/)
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
        gsub_file("Procfile", /^.*$/m) { |match| "#{match}worker: bundle exec rake jobs:work" }
      end
    end
  end
end
