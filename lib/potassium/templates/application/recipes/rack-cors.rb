gather_gem('rack-cors', '~> 0.4.0')
after(:gem_install) do
  application %{
      # Enables CORS for all requests
      config.middleware.insert_before 0, "Rack::Cors" do
        allow do
          origins '*'
          resource '*',
            :headers => :any,
            :expose  => ['X-Page', 'X-PageTotal'],
            :methods => [:get, :post, :delete, :put, :options]
        end
      end
  }
end
