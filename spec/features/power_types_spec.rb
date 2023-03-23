require "spec_helper"

RSpec.describe "PowerTypes" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  it "adds the PowerTypes gem to Gemfile" do
    gemfile_content = IO.read("#{project_path}/Gemfile")
    expect(gemfile_content).to include("power-types")
  end

  it "adds the PowerTypes brief to README file" do
    readme = IO.read("#{project_path}/README.md")
    expect(readme).to include("Power-Types")
  end

  it "adds every power type directory" do
    [:commands, :services, :observers, :utils, :values].each do |type|
      commands_directory = "#{project_path}/app/#{type}"
      expect(File.directory?(commands_directory)).to eq(true)
    end
  end
end
