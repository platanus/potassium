authentication_framework = {
  devise: ->{
    gather_gem 'devise'

    after(:gem_install) do
      generate "devise:install"

      if auth_model = get(:authentication_model)
        generate "devise #{auth_model.to_s}"
      end

      gsub_file "config/initializers/devise.rb", /(\# config.secret_key.+)/i do |match|
        match = "config.secret_key = ENV['DEVISE_SECRET_KEY']"
      end

      gsub_file "config/initializers/devise.rb", /(config.mailer_sender.+)/i do |match|
        match = "config.mailer_sender = ENV['DEFAULT_EMAIL_ADDRESS']"
      end

      append_to_file '.rbenv-vars.example', 'DEVISE_SECRET_KEY='
    end
  }
}

if get(:authentication)
  instance_exec(&(authentication_framework[get(:authentication)] || ->{ }))
end
