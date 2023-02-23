class Recipes::Cleanup < Rails::AppBuilder
  def create
    erase_comments "config/application.rb"
    erase_comments "config/environments/production.rb"
    erase_comments "config/environments/test.rb"
    erase_comments "config/environments/development.rb"
  end
end
