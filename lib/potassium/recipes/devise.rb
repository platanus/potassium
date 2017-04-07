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

  def add_devise # rubocop:disable MethodLength
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

      append_to_file '.env.development', "DEVISE_SECRET_KEY=\n"
      add_readme_section :internal_dependencies, :devise

      temp_append_path = 'config/devise_job_append.rb'
      template '../assets/config/devise.rb', temp_append_path
      append_to_file 'config/initializers/devise.rb', File.read(temp_append_path)
      File.delete temp_append_path

      insert_into_file "app/models/#{auth_model}.rb", ':job_emailable, ', after: "devise "
    end
  end
end
