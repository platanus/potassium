class Recipes::Mjml < Rails::AppBuilder
  def create
    return if get(:email_service).to_s.downcase.to_sym == :none

    gather_gem 'mjml-rails'
    after(:gem_install) do
      run 'yarn add mjml'
      mjml_config
    end
  end

  def installed?
    gem_exists?(/mjml-rails/)
  end

  def install
    create
  end
end

private

def mjml_config
  copy_file '../assets/app/views/layouts/default_mail.html.mjml',
            'app/views/layouts/default_mail.html.mjml', force: true
  copy_file '../assets/app/mailers/example_mailer.rb', 'app/mailers/example_mailer.rb', force: true
  copy_file '../assets/app/views/example_mailer/example_mail.html.mjml',
            'app/views/example_mailer/example_mail.html.mjml', force: true
  copy_file '../assets/public/mails/platanus-logo.png',
            'public/mails/platanus-logo.png', force: true
end
