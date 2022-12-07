class Recipes::ErrorReporting < Rails::AppBuilder
  def ask
    response = answer(:sentry) do
      Ask.confirm("Do you need to report application errors with Sentry?")
    end
    set(:report_error, response)
  end

  def create
    if selected?(:report_error)
      gather_gem 'sentry-rails'
      template '../assets/config/sentry.rb.erb', 'config/initializers/sentry.rb'
      append_to_file '.env.development', "SENTRY_DSN=\n"
      add_readme_section :internal_dependencies, :sentry
    end
  end

  def install
    set(:report_error, true)
    create
  end

  def installed?
    gem_exists?(/sentry-rails/) && file_exist?('config/initializers/sentry.rb')
  end
end
