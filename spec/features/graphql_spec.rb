require "spec_helper"

RSpec.describe "GraphQL" do
  context 'when using only graphql' do
    before :all do
      drop_dummy_database
      remove_project_directory
      create_dummy_project("api" => :graphql)
    end

    it "adds graphql related gems to Gemfile" do
      gemfile_content = IO.read("#{project_path}/Gemfile")
      expect(gemfile_content).to include("gem 'graphql'")
      expect(gemfile_content).to include("gem 'graphql_playground-rails'")
      expect(gemfile_content).not_to include("gem 'graphiql'")
    end

    it 'installs and sets up graphql' do
      schema = IO.read(
        "#{project_path}/app/graphql/#{PotassiumTestHelpers::APP_NAME.dasherize.tr('-', '_')}_schema.rb"
      )
      expect(schema).to include(
        "class #{PotassiumTestHelpers::APP_NAME.titleize.delete(' ')}Schema < GraphQL::Schema"
      )

      base_mutation = IO.read("#{project_path}/app/graphql/mutations/base_mutation.rb")
      expect(base_mutation).to include('Types::Base::Base')
      expect(base_mutation).not_to include('input_object_class')
      expect(base_mutation).not_to include('RelayClassic')

      controller = IO.read("#{project_path}/app/controllers/graphql_controller.rb")
      expect(controller).to include('skip_before_action :verify_authenticity_token')
    end

    it 'sets up graphql playground' do
      routes = IO.read("#{project_path}/config/routes.rb")
      expect(routes).to include(
        'mount GraphqlPlayground::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"'
      )
      config = IO.read("#{project_path}/config/initializers/graphql_playground.rb")
      expect(config).to include('GraphqlPlayground::Rails.configure do |config|')
    end
  end

  context 'when using authentication' do
    before :all do
      drop_dummy_database
      remove_project_directory
      create_dummy_project("api" => :graphql, "devise": true)
    end

    it 'gathers jwt gem' do
      gemfile_content = IO.read("#{project_path}/Gemfile")
      expect(gemfile_content).to include("gem 'jwt'")
    end

    it 'Adds auth related mutation and controller' do
      controller = IO.read("#{project_path}/app/controllers/graphql_controller.rb")
      expect(controller).to include('get_current_user')
      expect(controller).to include(
        "#{PotassiumTestHelpers::APP_NAME.titleize.delete(' ')}Schema.execute"
      )

      mutation_type = IO.read("#{project_path}/app/graphql/types/mutation_type.rb")
      expect(mutation_type).to include('field :login, mutation: Mutations::LoginMutation')

      login_mutation = IO.read("#{project_path}/app/graphql/mutations/login_mutation.rb")
      expect(login_mutation).to include('class Mutations::LoginMutation < Mutations::BaseMutation')
    end
  end
end
