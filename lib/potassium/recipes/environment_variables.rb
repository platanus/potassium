class Recipes::EnvironmentVariables < Rails::AppBuilder
  def create
    template '../assets/.env.test.erb', '.env.test'
    copy_file '../assets/lib/environment_variables.rb', 'lib/environment_variables.rb'

    application(before_configuration_require)
  end

  private

  def before_configuration_require
    <<~RUBY
      config.before_configuration do
        require Rails.root.join('lib/environment_variables.rb')
      end
    RUBY
  end
end
