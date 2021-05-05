class Recipes::Monitoring < Rails::AppBuilder
  def create
    gather_gem('scout_apm')
  end
end
