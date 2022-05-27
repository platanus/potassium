class Recipes::Api < Rails::AppBuilder
  def ask
    api_support = answer(:api) { Ask.confirm("Do you want to enable API support?") }
    set :api, api_support
  end

  def create
    add_power_api if get(:api)
  end

  def install
    ask
    create
  end

  def installed?
    gem_exists?(/power_api/)
  end

  private

  def add_power_api
    gather_gem 'power_api', '~> 2.0'

    gather_gems(:development, :test) do
      gather_gem 'rswag-specs'
    end

    add_readme_section :internal_dependencies, :power_api
    rubocop_example = "RSpec:\n  Language:\n    Includes:\n      Examples:\n        - run_test!"
    append_to_file('.rubocop.yml', rubocop_example)

    after(:gem_install) do
      generate "power_api:install"
      generate "power_api:internal_api_config"
    end
  end
end
