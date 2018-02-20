require "spec_helper"

RSpec.describe "Rswag" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("api" => true, "rswag" => true)
    @gemfile_content = IO.read("#{project_path}/Gemfile")
  end

  it "adds the rswag-api gem to Gemfile" do
    expect(@gemfile_content).to include("gem 'rswag-api'")
  end

  it "adds the rswag-ui gem to Gemfile" do
    expect(@gemfile_content).to include("gem 'rswag-ui'")
  end

  it "adds the rswag-specs gem to Gemfile" do
    expect(@gemfile_content).to include("gem 'rswag-specs'")
  end

  it "adds Api engine to routes file" do
    routes = IO.read("#{project_path}/config/routes.rb")
    expect(routes).to include("mount Rswag::Api::Engine => '/api-docs'")
  end

  it "adds Ui engine to routes file" do
    routes = IO.read("#{project_path}/config/routes.rb")
    expect(routes).to include("mount Rswag::Ui::Engine => '/api-docs'")
  end

  it "adds the Rswag brief to README file" do
    readme = IO.read("#{project_path}/README.md")
    expect(readme).to include("Rswag")
  end

  it "adds the rswag-api.rb file" do
    rswag_api = IO.read("#{project_path}/config/initializers/rswag-api.rb")
    expect(rswag_api).to include("c.swagger_root")
  end

  it "adds the rswag-ui.rb file" do
    rswag_ui = IO.read("#{project_path}/config/initializers/rswag-ui.rb")
    expect(rswag_ui).to include("c.swagger_endpoint")
  end

  it "adds swagger_helper.rb file" do
    swagger_helper = IO.read("#{project_path}/spec/swagger_helper.rb")
    expect(swagger_helper).to include("config.swagger_root")
  end
end
