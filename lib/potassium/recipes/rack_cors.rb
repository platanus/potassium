class Recipes::RackCors < Rails::AppBuilder
  def install
    create
  end

  def create
    gather_gem('rack-cors', '~> 0.4.0')
    after(:gem_install) do
      rack_cors_config =
        <<~RUBY
          config.middleware.insert_before 0, Rack::Cors do
            allow do
              origins '*'
              resource '*',
                headers: :any,
                expose: ['X-Page', 'X-PageTotal'],
                methods: [:get, :post, :delete, :put, :options]
            end
          end

        RUBY

      application rack_cors_config
    end
  end
end
