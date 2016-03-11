class Recipes::Ci < Recipes::Base
  def create
    if t.get(:heroku)
      t.copy_file '../assets/Dockerfile.ci', 'Dockerfile.ci'
      t.copy_file '../assets/circle.yml', 'circle.yml'

      t.template '../assets/bin/cibuild.erb', 'bin/cibuild'
      t.run "chmod a+x bin/cibuild"

      t.copy_file '../assets/docker-compose.ci.yml', 'docker-compose.ci.yml'

      compose = DockerHelpers.new('docker-compose.ci.yml')

      if t.selected?(:database, :mysql)
        service = <<-YAML
          image: "mysql:5.6.23"
          environment:
            MYSQL_ALLOW_EMPTY_PASSWORD: 'true'
        YAML
        compose.add_service("mysql", service)
        compose.add_link('test', 'mysql')
        compose.add_env('test', 'MYSQL_HOST', 'mysql')
        compose.add_env('test', 'MYSQL_PORT', '3306')

      elsif t.selected?(:database, :postgresql)
        service = <<-YAML
          image: "postgres:9.4.5"
          environment:
            POSTGRES_USER: postgres
            POSTGRES_PASSWORD: ''
        YAML
        compose.add_service("postgresql", service)
        compose.add_link('test', 'postgresql')
        compose.add_env('test', 'POSTGRESQL_USER', 'postgres')
        compose.add_env('test', 'POSTGRESQL_HOST', 'postgresql')
        compose.add_env('test', 'POSTGRESQL_PORT', '5432')
      end
    end
  end
end
