class Recipes::Devise < Rails::AppBuilder
  def ask
    use_devise = answer(:devise) do
      Ask.confirm "Do you want to use Devise for authentication? (required for ActiveAdmin)"
    end

    if use_devise
      set(:authentication, use_devise)
      ask_for_devise_model
    end
  end

  def create
    add_devise if selected?(:authentication)
  end

  def install
    ask_for_devise_model
    add_devise
  end

  def installed?
    gem_exists?(/devise/)
  end

  private

  def ask_for_devise_model
    create_user_model = answer(:"devise-user-model") do
      Ask.confirm "Do you want to create a user model for Devise?"
    end

    set(:authentication_model, :user) if create_user_model
  end

  def add_devise
    gather_gem 'devise'
    gather_gem 'devise-i18n'

    after(:gem_install) do
      generate "devise:install"

      if auth_model = get(:authentication_model)
        generate "devise #{auth_model}"
      end

      gsub_file "config/initializers/devise.rb", /(\# config.secret_key.+)/i do |_match|
        "config.secret_key = ENV['DEVISE_SECRET_KEY']"
      end

      gsub_file "config/initializers/devise.rb", /(config.mailer_sender.+)/i do |_match|
        "config.mailer_sender = ENV['DEFAULT_EMAIL_ADDRESS']"
      end

      gsub_file "config/initializers/devise.rb", /(\# config.pepper.+)/i do |_match|
        "# config.pepper = 'onhcylrat7x8bjyr5o15sxaix3vbu0sl'"
      end

      append_to_file '.env.example', 'DEVISE_SECRET_KEY='
      append_to_file '.env', 'DEVISE_SECRET_KEY='
      add_readme_section :internal_dependencies, :devise
    end
  end
end
