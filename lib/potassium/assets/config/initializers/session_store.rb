# https://github.com/redis-store/redis-store/issues/358#issuecomment-1537920008
class RedisClient::Config
  alias original_initialize initialize

  def initialize(**kwargs)
    # remove not supported kwargs
    original_initialize(
      **kwargs.except(:raw, :serializer, :marshalling, :namespace, :scheme)
    )
  end
end

Rails.application.config.session_store :redis_store, {
  servers: [{
    url: ENV['REDIS_URL']
  }],
  expire_after: 30.days,
  key: '_app_session',
  secure: Rails.env.production?
}
