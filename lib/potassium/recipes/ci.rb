class Recipes::Ci < Rails::AppBuilder
  def create
    copy_file '../assets/Dockerfile.ci', 'Dockerfile.ci'
    copy_file '../assets/.circleci/config.yml', '.circleci/config.yml'

    template '../assets/bin/cibuild.erb', 'bin/cibuild'
    run "chmod a+x bin/cibuild"

    copy_file '../assets/docker-compose.ci.yml', 'docker-compose.ci.yml'

    gather_gems(:test) do
      gather_gem 'rspec_junit_formatter', '0.2.2'
    end

    compose = DockerHelpers.new('docker-compose.ci.yml')

    if selected?(:database, :mysql)
      srv =
        <<~YAML
          image: mysql:#{Potassium::MYSQL_VERSION}
          environment:
            MYSQL_ALLOW_EMPTY_PASSWORD: 'true'
        YAML
      compose.add_service("mysql", srv)
      compose.add_link('test', 'mysql')
      compose.add_env('test', 'MYSQL_HOST', 'mysql')
      compose.add_env('test', 'MYSQL_PORT', '3306')

    elsif selected?(:database, :postgresql)
      srv =
        <<~YAML
          image: "postgres:#{Potassium::POSTGRES_VERSION}"
          environment:
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: ''
        YAML
      compose.add_service("postgresql", srv)
      compose.add_link('test', 'postgresql')
      compose.add_env('test', 'POSTGRESQL_USER', 'postgres')
      compose.add_env('test', 'POSTGRESQL_HOST', 'postgresql')
      compose.add_env('test', 'POSTGRESQL_PORT', '5432')
    end

    add_readme_header :ci

    application 'config.assets.js_compressor = :uglifier', env: 'test'
  end
end
