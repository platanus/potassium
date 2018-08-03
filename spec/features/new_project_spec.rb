require "spec_helper"
require "rubocop"

RSpec.describe "A new project" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  it "is correctly bundled" do
    expect { on_project { `bundle exec rails -v` } }.to_not output.to_stderr
  end

  it "is a valid rubocop project" do
    on_project do
      expect(run_rubocop).to eq(true)
    end
  end

  it "configures postgresql" do
    database_config_file = IO.read("#{project_path}/config/database.yml")
    gemfile = IO.read("#{project_path}/Gemfile")

    expect(database_config_file).to include(%{adapter: postgresql})
    expect(gemfile).to include %{gem 'pg'}
  end

  it "configures aws" do
    gemfile_content = IO.read("#{project_path}/Gemfile")
    expect(gemfile_content).to include("'aws-sdk', '~> 3'")

    initializer = IO.read("#{project_path}/config/initializers/aws.rb")
    expect(initializer).to include("Aws::VERSION")
  end

  it "configures the correct ruby version" do
    ruby_version_file = IO.read("#{project_path}/.ruby-version")

    expect(ruby_version_file).to eq("2.4")
  end

  it "setup ssl" do
    content = IO.read("#{project_path}/config/environments/production.rb")

    expect(content).to include %{force_ssl = true}
  end

  context "seeds related issues" do
    it "creates fake data loader module" do
      content = IO.read("#{project_path}/lib/fake_data_loader.rb")

      expect(content).to include %{module FakeDataLoader}
    end

    it "creates load fake data task" do
      content = IO.read("#{project_path}/lib/tasks/db/fake_data.rake")

      expect(content).to include %{FakeDataLoader.load}
    end

    it "overrides default seed file" do
      content = IO.read("#{project_path}/db/seeds.rb")

      expect(content).to include %{without duplicating the information}
    end
  end
end
