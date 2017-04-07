class Recipes::PowerTypes < Rails::AppBuilder
  def create
    add_power_types
    generate_folders
  end

  def install
    add_power_types
    generate_folders
  end

  def installed?
    gem_exists?(/power-types/)
  end

  private

  def add_power_types
    gather_gem 'power-types'
    add_readme_section :internal_dependencies, :power_types
  end

  def generate_folders
    after(:gem_install) do
      generate "power_types:init"
    end
  end
end
