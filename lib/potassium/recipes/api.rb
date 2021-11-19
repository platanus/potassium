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
    gem_exists?(/power_api/) || gem_exists?(/graphql/)
  end

  private

  def add_power_api
    gather_gem 'power_api'

    gather_gems(:development, :test) do
      gather_gem 'rswag-specs'
    end

    add_readme_section :internal_dependencies, :power_api
    rubocop_example = "RSpec:\n  Language:\n    Includes:\n      Examples:\n        - run_test!"
    append_to_file('.rubocop.yml', rubocop_example)

    after(:gem_install) do
      generate "power_api:install"
    end
  end

  def add_graphql
    gather_gem 'graphql'
    if get(:authentication)
      gather_gem 'jwt'
    end
    gather_gems(:development, :test) do
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
      inject_into_file(
        'config/routes.rb',
        playground_route,
        after: 'post "/graphql", to: "graphql#execute"'
      )
      copy_file(
        "../assets/config/graphql_playground.rb",
        "config/initializers/graphql_playground.rb"
      )
      remove_dir 'app/graphql/types'
      directory '../assets/app/graphql/types', 'app/graphql/types'
      gsub_file 'app/graphql/mutations/base_mutation.rb', 'Types::Base', 'Types::Base::Base'
      directory '../assets/app/graphql/queries', 'app/graphql/queries'
      gsub_file 'app/graphql/mutations/base_mutation.rb', 'RelayClassic', ''
      gsub_file(
        'app/graphql/mutations/base_mutation.rb',
        "    input_object_class Types::Base::BaseInputObject\n", ''
      )

      if get(:authentication)
        copy_file(
          '../assets/app/graphql/graphql_controller.rb',
          'app/controllers/graphql_controller.rb',
          force: true
        )
        gsub_file(
          'app/controllers/graphql_controller.rb',
          'GqlSampleSchema',
          "#{get(:titleized_app_name).delete(' ')}Schema"
        )
        copy_file(
          '../assets/app/graphql/mutations/login_mutation.rb',
          'app/graphql/mutations/login_mutation.rb'
        )
        inject_into_file(
          'app/graphql/types/mutation_type.rb',
          "\n    field :login, mutation: Mutations::LoginMutation",
          after: 'class MutationType < Types::Base::BaseObject'
        )
        append_to_file(".env.development", "HMAC_SECRET=\n")
      end

      inject_into_file(
        'app/controllers/graphql_controller.rb',
        "\n\n  skip_before_action :verify_authenticity_token",
        after: '# protect_from_forgery with: :null_session'
      )

      add_readme_section :internal_dependencies, :graphql
    end
  end
end
