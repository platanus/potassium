class Recipes::Puma < Rails::AppBuilder
  def create
    gather_gems(:production) do
      gather_gem 'rack-timeout'
    end

    copy_file '../assets/config/puma.rb', 'config/puma.rb', force: true

    # Configure rack-timout
    application "Rack::Timeout.timeout = (ENV[\"RACK_TIMEOUT\"] || 10).to_i", env: "production"
  end
end
