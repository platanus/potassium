class Recipes::Draper < Rails::AppBuilder
  def ask
    draper = answer(:draper) { Ask.confirm('Do you want to use Draper to decorate models?') }
    set(:draper, draper)
  end

  def create
    return unless selected?(:draper)

    add_draper
  end

  def installed?
    gem_exists?(/draper/)
  end

  def install
    add_draper
  end

  def add_draper
    gather_gem 'draper', '~> 3.1'
    add_readme_section :internal_dependencies, :draper
    create_file 'app/decorators/.keep'
  end
end
