require 'sidekiq'
require 'sidekiq/web'

config_file = "#{Rails.root}/config/redis.yml"
redis_config = YAML.safe_load(ERB.new(File.read(config_file)).result)[Rails.env]

redis_conn = proc do
  Redis.new(redis_config)
end
Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: 2, &redis_conn)
end
Sidekiq.configure_server do |config|
  config.redis = ConnectionPool.new(size: 7, &redis_conn)
  config.server_middleware do |chain|
    chain.remove Sidekiq::Middleware::Server::RetryJobs
  end
end

if !Rails.env.development?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == ENV["SIDEKIQ_ADMIN_PASSWORD"]
  end
end
