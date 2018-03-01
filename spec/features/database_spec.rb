require "spec_helper"

RSpec.describe "Database" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  it "adds the Strong Migrations gem to Gemfile" do
    gemfile_content = IO.read("#{project_path}/Gemfile")
    expect(gemfile_content).to include("gem 'strong_migrations'")
  end
end
