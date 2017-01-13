class Recipes::Schedule < Rails::AppBuilder
  def ask
    use_schedule = answer(:clockwork) { Ask.confirm("Do you need to schedule processes or tasks?") }
    set(:scheduled, use_schedule)
  end

  def create
    if selected?(:scheduled)
      gather_gem 'clockwork'
      template '../assets/config/clock.rb.erb', 'config/clock.rb'
      add_readme_section :internal_dependencies, :clockwork

      if selected?(:heroku)
        procfile('scheduler', 'bundle exec clockwork config/clock.rb')
      end
    end
  end

  def install
    heroku = load_recipe(:heroku)
    set(:heroku, heroku.installed?)

    error_reporting = load_recipe(:error_reporting)
    set(:report_error, error_reporting.installed?)

    set(:scheduled, true)
    create
  end

  def installed?
    gem_exists?(/clock/) && file_exist?('config/clock.rb')
  end
end
