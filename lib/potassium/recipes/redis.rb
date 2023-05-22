class Recipes::Redis < Rails::AppBuilder
  def create
    add_redis
    add_docker_compose_redis_config
    set_redis_dot_env
  end

  def install
    create
  end

  def installed?
    gem_exists?(/redis-actionpack/)
  end

  def add_redis
    run_action(:install_redis) do
      gather_gem("redis-actionpack")
      copy_file("../assets/redis.yml", "config/redis.yml", force: true)
    end
  end

  private

  def add_docker_compose_redis_config
    compose = DockerHelpers.new('docker-compose.yml')

    service_definition =
      <<~YAML
        image: redis:6.2.12
        ports:
          - 6379
        volumes:
          - redis_data:/data
      YAML

    compose.add_service('redis', service_definition)
    compose.add_volume('redis_data')
  end

  def set_redis_dot_env
    append_to_file(
      '.env.development',
      <<~TEXT
        REDIS_HOST=127.0.0.1
        REDIS_PORT=COMMAND_EXPAND(make services-port SERVICE=redis PORT=6379)
        REDIS_URL=redis://${REDIS_HOST}:${REDIS_PORT}/1
      TEXT
    )
  end
end
