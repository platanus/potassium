class Recipes::Api < Rails::AppBuilder
  def ask
    api_interfaces = {
      rest: "REST (with Power API)",
      graphql: "GraphQL (beta)",
      none: "None, thanks"
    }
    api_interface = answer(:api) do
      api_interfaces.keys[Ask.list("Which API interface are you using?", api_interfaces.values)]
    end
    set :api, api_interface.to_sym
  end

  def create
    if get(:api) == :graphql
      add_graphql
    elsif get(:api) == :rest
      add_power_api
    end
  end

  def install
    ask
    create
  end

  def installed?
    gem_exists?(/power_api/)
  end

  private

  def add_power_api
    gather_gem 'power_api'

    gather_gems(:development, :test) do
      gather_gem 'rswag-specs'
    end

    add_readme_section :internal_dependencies, :power_api

    after(:gem_install) do
      generate "power_api:install"
    end
  end

  def add_graphql
    gather_gem 'graphql'
    gather_gems(:development) do
      gather_gem 'graphql_playground-rails'
    end

    after(:gem_install) do
      generate "graphql:install --skip_graphiql"
      playground_route = <<~HEREDOC
      \n
        if Rails.env.development?
          mount GraphqlPlayground::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
        end
      HEREDOC
      inject_into_file('config/routes.rb',
        playground_route,
        after: 'post "/graphql", to: "graphql#execute"'
      )
      copy_file(
        "../assets/config/graphql_playground.rb",
        "config/initializers/graphql_playground.rb"
      )
      remove_dir 'app/graphql/types'
      directory '../assets/app/graphql/types', 'app/graphql/types'
      gsub_file 'app/graphql/mutations/base_mutation.rb', 'Types::Base', 'Types::Base::'
      directory '../assets/app/graphql/queries', 'app/graphql/queries'
    end
  end
end
