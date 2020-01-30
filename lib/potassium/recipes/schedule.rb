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
    end
    template '../assets/sidekiq_scheduler.yml', 'config/sidekiq.yml', force: true
  end

  def install
    set(:schedule, true)
    create
  end

  def installed?
    gem_exists?(/sidekiq-scheduler/) && file_exist?('config/sidekiq.yml')
  end
end
