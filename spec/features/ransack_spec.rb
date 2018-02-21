require "spec_helper"

RSpec.describe "Ransack" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("ransack" => true)
  end

  it "add the Ransack gem to Gemfile" do
    gemfile_content = IO.read("#{project_path}/Gemfile")
    expect(gemfile_content).to include("gem 'ransack'")
  end

  it "adds the Ransack brief to README file" do
    readme = IO.read("#{project_path}/README.md")
    expect(readme).to include("Ransack")
  end
end
