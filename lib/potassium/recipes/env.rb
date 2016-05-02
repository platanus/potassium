class Recipes::Env < Rails::AppBuilder
  def create
    gather_gems(:development, :test) do
      gather_gem('dotenv-rails')
    end

    template '../assets/.env.development.erb', '.env.development'
    append_to_file '.gitignore', ".env.local\n"
    append_to_file '.gitignore', ".env\n"

    env_config =
      <<-RUBY.gsub(/^ {7}/, '')
         config.before_configuration do
           Dotenv.load(Dotenv::Railtie.root.join('.env.development'))
         end
         RUBY
    application env_config.strip, env: 'test'
  end
end
