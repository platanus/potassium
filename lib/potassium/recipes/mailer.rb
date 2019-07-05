class Recipes::Mailer < Rails::AppBuilder
  def ask
    email_services = {
      aws_ses: "Amazon SES",
      sendgrid: "Sendgrid (beta)",
      none: "None, thanks"
    }

    email_service = answer(:email_service) do
      email_services.keys[Ask.list("Which email service are you using?", email_services.values)]
    end
    set :email_service, email_service.to_sym
  end

  def create
    email_service = email_services(get(:email_service))
    return if email_service.nil?

    set(:mailer_delivery_method, email_service[:delivery_method])
    set(:mailer_gem_name, email_service[:gem_name])

    add_readme_header :mailing

    dependencies(email_service)
    config(email_service)

    background_processor = load_recipe(:background_processor)
    background_processor.add_sidekiq unless background_processor.installed?
  end

  def install
    ask
    create
  end

  private

  def email_services(service_name)
    email_services = {
      sendgrid: {
        name: 'sendgrid',
        gem_name: 'send_grid_mailer',
        delivery_method: :sendgrid
      },
      aws_ses: {
        name: 'aws_ses',
        gem_name: 'aws-sdk-rails',
        delivery_method: :aws_sdk
      }
    }
    email_services[service_name]
  end

  def dependencies(service)
    if service[:version]
      gather_gem service[:gem_name], service[:version]
    else
      gather_gem service[:gem_name]
    end
    gather_gem 'recipient_interceptor'
  end

  def config(service)
    template "../assets/config/mailer.rb.erb", 'config/mailer.rb'
    gsub_file 'config/environments/production.rb', /$\s*config.action_mailer.*/, ''
    append_to_file '.env.development', "APPLICATION_HOST=localhost:3000\n"
    append_to_file '.env.development', "EMAIL_RECIPIENTS=\n"

    mailer_config =
      <<~RUBY
        require Rails.root.join("config", "mailer")
      RUBY

    prepend_file "config/environments/production.rb", mailer_config
    copy_file '../assets/app/mailers/application_mailer.rb', 'app/mailers/application_mailer.rb', force: true

    send(service[:name])
  end

  def sendgrid
    append_to_file '.env.development', "SENDGRID_API_KEY=\n"
    sendgrid_settings = <<~RUBY
      Rails.application.config.action_mailer.sendgrid_settings = {
        api_key: ENV['SENDGRID_API_KEY']
      }
    RUBY
    inject_into_file 'config/mailer.rb', sendgrid_settings,
      after: "Rails.application.config.action_mailer.delivery_method = :sendgrid\n"
    sendgrid_dev_settings = <<~RUBY
      Rails.application.config.action_mailer.sendgrid_dev_settings = {
        api_key: ENV['SENDGRID_API_KEY']
      }
    RUBY
    application sendgrid_dev_settings, env: "development"
    application "config.action_mailer.delivery_method = :sendgrid_dev", env: "development"
  end

  def aws_ses
    gather_gems(:development) { gather_gem("letter_opener") }
    application "config.action_mailer.delivery_method = :letter_opener", env: "development"
  end
end
