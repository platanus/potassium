require "spec_helper"

RSpec.describe "Api" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("api" => :rest)
  end

  it "adds power_api related gems to Gemfile" do
    gemfile_content = IO.read("#{project_path}/Gemfile")
    expect(gemfile_content).to include("gem 'power_api'")
    expect(gemfile_content).to include("gem 'rswag-specs'")
  end

  it "adds the power_api brief to README file" do
    readme = IO.read("#{project_path}/README.md")
    expect(readme).to include("Power API")
  end

  it "installs power_api" do
    content = IO.read("#{project_path}/app/controllers/api/base_controller.rb")
    expect(content).to include("Api::BaseController < PowerApi::BaseController")
  end

  it "installs internal API mode" do
    content = IO.read("#{project_path}/app/controllers/api/internal/base_controller.rb")
    expect(content).to include("Api::Internal::BaseController < Api::BaseController")
  end
end
