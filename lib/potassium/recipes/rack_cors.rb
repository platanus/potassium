class Recipes::RackCors < Rails::AppBuilder
  def install
    create
  end

  def create
    gather_gem('rack-cors', '~> 1.1')
    recipe = self
    after(:gem_install) do
      application recipe.rack_cors_config
    end
  end

  def rack_cors_config
    <<~RUBY
      config.middleware.insert_before 0, Rack::Cors do
        allow do
          origins '*'
          resource '/public/*', headers: :any, methods: :get
          resource '/api/*',
            headers: :any,
            expose: ['X-Page', 'X-PageTotal'],
            methods: [:get, :post, :patch, :put, :delete, :options]
        end
      end

    RUBY
  end
end
