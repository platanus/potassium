require "spec_helper"

RSpec.describe "Clockwork" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("clockwork" => true)
  end

  it "adds the Clockwork gem to Gemfile" do
    gemfile_content = IO.read("#{project_path}/Gemfile")

    expect(gemfile_content).to include("gem 'clockwork'")
  end

  it "creates the config for clockwork scheduler" do
    initializer_content = IO.read("#{project_path}/config/clock.rb")

    expect(initializer_content).to include("module Clockwork")
  end
end
