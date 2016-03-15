class Recipes::Puma < Recipes::Base
  def create
    t.gather_gem 'puma'

    t.gather_gems(:production, :staging) do
      gather_gem 'rack-timeout'
    end

    t.copy_file '../assets/config/puma.rb', 'config/puma.rb'

    # Configure rack-timout
    rack_timeout_config =
      <<-RUBY.gsub(/^ {9}/, '')
         Rack::Timeout.timeout = (ENV["RACK_TIMEOUT"] || 10).to_i
         RUBY

    t.append_file "config/environments/production.rb", rack_timeout_config
  end
end
