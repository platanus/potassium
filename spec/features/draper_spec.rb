require "spec_helper"

RSpec.describe "Draper" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("draper" => true)
  end

  it "adds the Draper gem to Gemfile" do
    gemfile_content = IO.read("#{project_path}/Gemfile")
    expect(gemfile_content).to include("gem 'draper'")
  end

  it "adds the Draper brief to README file" do
    readme = IO.read("#{project_path}/README.md")
    expect(readme).to include("Draper")
  end

  it "adds decorators directory" do
    content = IO.read("#{project_path}/app/decorators/.keep")
    expect(content).to be_empty
  end
end
