class Recipes::DatabaseContainer < Rails::AppBuilder
  CONTAINER_VARS = {
    postgresql: { port: 5432, user: 'postgres' },
    mysql: { port: 3306, user: 'root' }
  }

  POSTGRESQL_SERVICE =
    <<~YAML
      image: postgres:11
      ports:
        - #{CONTAINER_VARS[:postgresql][:port]}
      environment:
        POSTGRES_USER: #{CONTAINER_VARS[:postgresql][:user]}
        POSTGRES_PASSWORD: ''
      volumes:
        - postgresql_data:/var/lib/postgresql/data
    YAML

  MYSQL_SERVICE =
    <<~YAML
      image: mysql:5
      ports:
        - #{CONTAINER_VARS[:mysql][:port]}
      environment:
        MYSQL_ALLOW_EMPTY_PASSWORD: 'true'
      volumes:
       - mysql_data:/var/lib/mysql
    YAML

  def create
    copy_file '../assets/docker-compose.yml', 'docker-compose.yml'

    compose = DockerHelpers.new('docker-compose.yml')

    db_type = get(:database)
    compose.add_service(db_type.to_s, self.class.const_get("#{db_type}_service".upcase))
    compose.add_volume("#{db_type}_data")
    template '../assets/Makefile.erb', 'Makefile'

    run 'make services-up'

    set_env(db_type, CONTAINER_VARS[db_type][:port], CONTAINER_VARS[db_type][:user])
    set_dot_env(db_type, CONTAINER_VARS[db_type][:port], CONTAINER_VARS[db_type][:user])
  end

  def install
    database_config = YAML.safe_load(IO.read('config/database.yml'), [], [], true)
    database = database_config['development']['adapter'].gsub(/\d+/, '').to_sym
    set :database, database

    template "../assets/config/database_#{database}.yml.erb", 'config/database.yml'

    setup_text = # setup file is templated on project creation, manual install is needed
      <<~TEXT
        # Set up required services
        make services-up

      TEXT

    insert_into_file 'bin/setup', setup_text, before: "# Set up database"
    run 'bin/setup'
    info "A new container with a #{get(:database)} database has been created."
  end

  def installed?
    file_exist?("docker-compose.yml")
  end

  private

  def set_env(_service_name, _port, _user)
    ENV["DB_PORT"] = `make services-port SERVICE=#{_service_name} PORT=#{_port}`.squish
    ENV["DB_USER"] = _user
  end

  def set_dot_env(_service_name, _port, _user)
    env_text =
      <<~TEXT

        # Database
        DB_HOST=127.0.0.1
        DB_PORT=$(make services-port SERVICE=#{_service_name} PORT=#{_port})
        DB_USER=#{_user}

      TEXT
    insert_into_file '.env.development', env_text, after: "WEB_CONCURRENCY=1\n"
  end
end
