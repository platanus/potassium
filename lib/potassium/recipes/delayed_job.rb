class Recipes::DelayedJob < Recipes::Base
  def ask
    use_delayed_job = t.answer(:"delayed-job") { Ask.confirm("Do you want to use delayed jobs?") }
    t.set(:delayed_job, use_delayed_job)
  end

  def create
    add_delayed_job if t.selected?(:delayed_job)
  end

  def install
    if t.gem_exists?(/delayed_job_active_record/)
      t.info "Delayed Job is already installed"
    else
      t.set(:heroku, t.gem_exists?(/rails_stdout_logging/))
      add_delayed_job
    end
  end

  private

  def add_delayed_job
    t.gather_gem "delayed_job_active_record"

    delayed_job_config = "config.active_job.queue_adapter = :delayed_job"
    t.application(delayed_job_config)

    t.after(:gem_install) do
      generate "delayed_job:active_record"
      run "bundle binstubs delayed_job"

      if selected?(:heroku)
        gsub_file "Procfile", /^.*$/m do |match|
          "#{match}worker: bundle exec rake jobs:work"
        end
      end
    end
  end
end
