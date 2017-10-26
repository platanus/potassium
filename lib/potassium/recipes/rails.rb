class Recipes::Rails < Rails::AppBuilder
  def create
    environment 'config.force_ssl = true', env: 'production'
  end
end
