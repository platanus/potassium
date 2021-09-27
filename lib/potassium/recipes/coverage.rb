class Recipes::Coverage < Rails::AppBuilder
  def create
    load_gems
    configure_rails_helper
    append_to_file('.gitignore', "/coverage/*\n")
  end

  def installed?
    gem_exists?(/simplecov/)
  end

  def install
    create
  end

  private

  def load_gems
    gather_gems(:test) do
      gather_gem 'simplecov'
      gather_gem 'simplecov_linter_formatter'
      gather_gem 'simplecov_text_formatter'
    end
  end

  def configure_rails_helper
    copy_file '../assets/testing/simplecov_config.rb', 'spec/simplecov_config.rb'

    after(:gem_install) do
      gsub_file 'spec/rails_helper.rb', "require 'rspec/rails'" do |match|
        "require 'simplecov_config'\n#{match}"
      end
    end
  end
end
