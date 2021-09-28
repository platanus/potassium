class Recipes::Testing < Rails::AppBuilder
  def create
    add_gems
    recipe = self

    after(:gem_install) do
      recipe.install_rspec
      recipe.install_guard
      recipe.create_rspec_binary
    end

    config_raise_delivery_errors_option
  end

  def install_rspec
    remove_dir 'test'
    generate "rspec:install"
    remove_file 'spec/rails_helper.rb'
    copy_file '../assets/testing/rails_helper.rb', 'spec/rails_helper.rb'
    remove_file '.rspec'
    copy_file '../assets/testing/.rspec', '.rspec'
    create_support_directories
  end

  def create_support_directories
    %w{
      custom_matchers
      shared_examples
      configurations
      helpers
    }.each do |directory|
      path = "spec/support/#{directory}"
      empty_directory(path)
      create_file("#{path}/.keep")
    end

    add_support_configuration_modules
  end

  def add_support_configuration_modules
    files = %w{
      factory_bot_config
      power_types_config
      shoulda_matchers_config
    }
    files << "devise_config" if selected?(:authentication)
    files.each do |config_module|
      copy_file(
        "../assets/testing/#{config_module}.rb",
        "spec/support/configurations/#{config_module}.rb"
      )
    end
  end

  def install_guard
    run "bundle exec guard init"
    run "bundle binstub guard"
    line = /guard :rspec, cmd: "bundle exec rspec" do\n/
    gsub_file 'Guardfile', line do
      "guard :rspec, cmd: \"bin/rspec\" do\n"
    end
  end

  def create_rspec_binary
    run "bundle binstubs rspec-core"
  end

  def add_gems
    gather_gems(:development, :test) do
      gather_gem('rspec-rails')
      gather_gem('factory_bot_rails')
      gather_gem('faker')
      gather_gem('guard-rspec', require: false)
      gather_gem('rspec-nc', require: false)
    end

    gather_gems(:test) do
      gather_gem('shoulda-matchers', require: false)
    end
  end

  def config_raise_delivery_errors_option
    raise_delivery_errors_regexp = /config.action_mailer.raise_delivery_errors = false\n/
    gsub_file 'config/environments/development.rb', raise_delivery_errors_regexp do
      "config.action_mailer.raise_delivery_errors = true"
    end
  end
end
