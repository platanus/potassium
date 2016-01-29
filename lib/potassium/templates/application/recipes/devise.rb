authentication_framework = {
  devise: -> do
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

      append_to_file '.rbenv-vars.example', 'DEVISE_SECRET_KEY='
    end
  end
}

if get(:authentication)
  instance_exec(&(authentication_framework[get(:authentication)] || -> {}))
end
