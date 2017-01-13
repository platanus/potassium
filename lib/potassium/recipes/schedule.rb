class Recipes::Schedule < Rails::AppBuilder
  def ask
    use_schedule = answer(:schedule) { Ask.confirm("Do you need to schedule processes or tasks?") }
    set(:schedule, use_schedule)
  end

  def create
    if selected?(:schedule)
      gather_gem 'clockwork'
      copy_file '../assets/config/clock.rb', 'config/clock.rb'
      add_readme_section :internal_dependencies, :clockwork

      if selected?(:heroku)
        procfile('scheduler', 'bundle exec clockwork config/clock.rb')
      end
    end
  end

  def install
    heroku = load_recipe(:heroku)
    set(:heroku, heroku.installed?)
    set(:schedule, true)
    create
  end

  def installed?
    gem_exists?(/clock/) && file_exist?('config/clock.rb')
  end
end
