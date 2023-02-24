require "spec_helper"

RSpec.describe "schedule" do
  let(:sidekiq_config) { IO.read("#{project_path}/config/sidekiq.yml") }

  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project(
      "schedule" => true, "background_processor" => true, "email_service" => "sendgrid"
    )
  end

  it "adds the sidekiq-scheduler gem to Gemfile" do
    gemfile_content = IO.read("#{project_path}/Gemfile")
    expect(gemfile_content).to include("sidekiq-scheduler")
  end

  it "adds schedule section to sidekiq config" do
    expect(sidekiq_config).to include(":schedule:")
  end

  it "doesn't remove mailers queue" do
    expect(sidekiq_config).to include("- mailers")
  end

  it "adds scheduler ui to the sidekiq initializer" do
    content = IO.read("#{project_path}/config/initializers/sidekiq.rb")
    expect(content).to include("require 'sidekiq-scheduler/web'")
  end
end
