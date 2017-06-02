require "spec_helper"

RSpec.describe "schedule" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("schedule" => true)
  end

  it "adds the sidekiq-scheduler gem to Gemfile" do
    gemfile_content = IO.read("#{project_path}/Gemfile")
    expect(gemfile_content).to include("gem 'sidekiq-scheduler'")
  end

  it "creates the config with schedule" do
    initializer_content = IO.read("#{project_path}/config/sidekiq.yml")
    expect(initializer_content).to include(":schedule:")
  end
end
