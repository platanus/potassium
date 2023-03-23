require "spec_helper"

RSpec.describe "Error Reporting" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("sentry" => true)
  end

  it "adds the Sentry gem to Gemfile" do
    gemfile_content = IO.read("#{project_path}/Gemfile")

    expect(gemfile_content).to include("sentry-rails")
  end

  it "creates the initializer" do
    initializer_content = IO.read("#{project_path}/config/initializers/sentry.rb")

    expect(initializer_content).to include("Sentry.init")
  end

  it "adds the environment variable to .env.development" do
    env_content = IO.read("#{project_path}/.env.development")

    expect(env_content).to include("SENTRY_DSN=")
  end
end
