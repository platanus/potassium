class Recipes::Api < Rails::AppBuilder
  def ask
    api_support = answer(:api) { Ask.confirm("Do you want to enable API support?") }
    set(:api_support, api_support)
  end

  def create
    add_api if get(:api_support)
  end

  def install
    add_api
  end

  def installed?
    gem_exists?(/power_api/)
  end

  private

  def add_api
    gather_gem 'power_api'

    gather_gems(:development, :test) do
      gather_gem 'rswag-specs'
    end

    add_readme_section :internal_dependencies, :power_api

    after(:gem_install) do
      generate "power_api:install"
    end
  end
end
