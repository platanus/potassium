if selected?(:delayed_job)
  gather_gem "delayed_job_active_record"

  delayed_job_config = "config.active_job.queue_adapter = :delayed_job"
  application(delayed_job_config)

  after(:gem_install) do
    generate "delayed_job:active_record"
    run "bundle binstubs delayed_job"

    if selected?(:heroku)
      gsub_file "Procfile", /^.*$/m do |match|
        "#{match}worker: bundle exec rake jobs:work"
      end
    end
  end
end
