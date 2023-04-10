class Recipes::Coverage < Rails::AppBuilder
  def create
    load_gems
    configure_rails_helper
    append_to_file('.gitignore', "/coverage/*\n")
    recipe = self
    after(:vite_install) do
      recipe.setup_coverage_dependencies
    end
  end

  def installed?
    gem_exists?(/simplecov/)
  end

  def install
    create
  end

  def setup_coverage_dependencies
    run "yarn add c8 --dev"
  end

  private

  def load_gems
    gather_gems(:test) do
      gather_gem 'simplecov'
      gather_gem 'simplecov_linter_formatter', '~> 0.2'
      gather_gem 'simplecov_text_formatter'
    end
  end

  def configure_rails_helper
    copy_file '../assets/testing/simplecov_config.rb', 'spec/simplecov_config.rb'

    after(:gem_install) do
      gsub_file 'spec/rails_helper.rb', "ENV['RACK_ENV'] ||= 'test'" do |match|
        "#{match}\nrequire 'simplecov_config'"
      end
    end
  end
end
