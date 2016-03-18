class Recipes::Staging < Rails::AppBuilder
  def create
    copy_file '../assets/config/environments/staging.rb', "config/environments/staging.rb"
  end
end
