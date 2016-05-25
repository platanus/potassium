class Recipes::Puma < Rails::AppBuilder
  def create
    gather_gem 'puma'

    gather_gems(:production) do
      gather_gem 'rack-timeout'
    end

    copy_file '../assets/config/puma.rb', 'config/puma.rb'

    # Configure rack-timout
    rack_timeout_config =
      <<-RUBY.gsub(/^ {9}/, '')
         Rack::Timeout.timeout = (ENV["RACK_TIMEOUT"] || 10).to_i
         RUBY

    append_file "config/environments/production.rb", rack_timeout_config
  end
end
