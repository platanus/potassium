require "spec_helper"

RSpec.describe "PowerTypes" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  it "adds the PowerTypes gem to Gemfile" do
    gemfile_content = IO.read("#{project_path}/Gemfile")
    expect(gemfile_content).to include("gem 'power-types'")
  end

  it "adds the PowerTypes brief to README file" do
    readme = IO.read("#{project_path}/README.md")
    expect(readme).to include("Power-Types")
  end

  it "adds commands directory" do
    commands_directory = "#{project_path}/app/commands"
    expect(File.directory?(commands_directory)).to eq(true)
  end

  it "adds services directory" do
    services_directory = "#{project_path}/app/services"
    expect(File.directory?(services_directory)).to eq(true)
  end
  it "adds utils directory" do
    utils_directory = "#{project_path}/app/utils"
    expect(File.directory?(utils_directory)).to eq(true)
  end
  it "adds values directory" do
    values_directory = "#{project_path}/app/values"
    expect(File.directory?(values_directory)).to eq(true)
  end
end
