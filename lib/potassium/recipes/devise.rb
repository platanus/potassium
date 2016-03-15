class Recipes::Devise < Recipes::Base
  def ask
    use_devise = t.answer(:devise) do
      Ask.confirm "Do you want to use Devise for authentication? (required for ActiveAdmin)"
    end

    if use_devise
      t.set(:authentication, use_devise)
      ask_for_devise_model
    end
  end

  def create
    add_devise
  end

  def install
    if t.gem_exists?(/devise/)
      t.info "Devise is already installed"
    else
      ask_for_devise_model
      add_devise
    end
  end

  private

  def ask_for_devise_model
    create_user_model = t.answer(:"devise-user-model") do
      Ask.confirm "Do you want to create a user model for Devise?"
    end

    t.set(:authentication_model, :user) if create_user_model
  end

  def add_devise
    t.gather_gem 'devise'
    t.gather_gem 'devise-i18n'

    t.after(:gem_install) do
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
    end
  end
end
