class Recipes::Schedule < Rails::AppBuilder
  def ask
    if selected?(:background_processor)
      response = answer(:schedule) { Ask.confirm("Do you need to schedule jobs?") }
    end
    set(:schedule, response)
  end

  def create
    if selected?(:schedule)
      gather_gem 'sidekiq-scheduler', '>= 3.0.1'
      add_readme_section :internal_dependencies, :sidekiq_scheduler
      append_schedule_section_to_yml
    end
  end

  def install
    set(:schedule, true)
    create
  end

  def installed?
    gem_exists?(/sidekiq-scheduler/) && file_exist?('config/sidekiq.yml')
  end

  private

  def append_schedule_section_to_yml
    append_to_file(
      'config/sidekiq.yml',
      <<-HERE.gsub(/^ {8}/, '')
        # :schedule:
          #  an_scheduled_task:
          #    cron: '0 * * * * *'  # Runs once per minute
          #    class: ExampleJob
          #    args: ['a', 'b']
      HERE
    )
  end
end
