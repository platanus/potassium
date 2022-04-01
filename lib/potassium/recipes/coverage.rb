class Recipes::Coverage < Rails::AppBuilder
  def create
    load_gems
    configure_rails_helper
    append_to_file('.gitignore', "/coverage/*\n")
    recipe = self
    after(:setup_jest) do
      recipe.configure_jest_coverage
    end
  end

  def installed?
    gem_exists?(/simplecov/)
  end

  def install
    create
  end

  def configure_jest_coverage
    json_file = File.read(Pathname.new("package.json"))
    js_package = JSON.parse(json_file)
    js_package = add_coverage_config(js_package)
    json_string = JSON.pretty_generate(js_package)
    create_file 'package.json', json_string, force: true
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

  def add_coverage_config(js_package)
    js_package['scripts']['test:changes'] = 'jest --changedSince=master'
    js_package['jest'] = js_package['jest'].merge(coverage_defaults)
    js_package
  end

  def coverage_defaults
    {
      collectCoverage: true,
      collectCoverageFrom: ['**/*.{js,ts,vue}', '!**/node_modules/**'],
      coverageReporters: ['text']
    }
  end
end
