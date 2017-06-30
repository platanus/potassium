require 'sidekiq'
require 'sidekiq/web'

redis_config = Rails.application.config_for(:redis)

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
Sidekiq.configure_server do |config|
  config.redis = redis_config
end

if !Rails.env.development?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'admin' && password == ENV["SIDEKIQ_ADMIN_PASSWORD"]
  end
end
