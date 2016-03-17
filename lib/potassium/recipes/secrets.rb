class Recipes::Secrets < Rails::AppBuilder
  def create
    template '../assets/config/secrets.yml.erb', 'config/secrets.yml', force: true
  end
end
