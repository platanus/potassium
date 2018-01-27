class Recipes::Draper < Rails::AppBuilder
  def ask
    draper = answer(:draper) { Ask.confirm('Do you want to use Draper to decorate models?') }
    set(:draper, draper)
  end

  def create
    return unless selected?(:draper)
    add_draper
    add_api_responder if selected?(:api_support)
  end

  def installed?
    gem_exists?(/draper/)
  end

  def install
    add_draper
    api_recipe = load_recipe(:api)
    add_api_responder if api_recipe.installed?
  end

  def add_draper
    gather_gem 'draper', '3.0.1'
    add_readme_section :internal_dependencies, :draper
    create_file 'app/decorators/.keep'
  end

  def add_api_responder
    after(:gem_install) do
      copy_file '../assets/api/draper_responder.rb', 'app/responders/api_responder.rb', force: true
    end
  end
end
