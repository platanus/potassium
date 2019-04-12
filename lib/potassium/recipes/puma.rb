class Recipes::Puma < Rails::AppBuilder
  def create
    gather_gems(:production) do
      gather_gem 'rack-timeout'
    end

    copy_file '../assets/config/puma.rb', 'config/puma.rb', force: true
  end
end
