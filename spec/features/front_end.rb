require "spec_helper"

RSpec.describe "Front end" do
  before(:all) { drop_dummy_database }
  before(:each) { remove_project_directory }

  it "creates a project without a front end framework" do
    create_dummy_project("front_end" => "None")
    gemfile = IO.read("#{project_path}/Gemfile")
    expect(gemfile).not_to include('webpacker')
  end

  it "creates a project without vue as front end framework" do
    create_dummy_project("front_end" => "angular")
    gemfile = IO.read("#{project_path}/Gemfile")
    node_modules_file = IO.read("#{project_path}/package.json")

    expect(gemfile).to include('webpacker')
    expect(node_modules_file).to include("\"@angular/core\"")
  end

  it "creates a project without vue as front end framework" do
    create_dummy_project("front_end" => "vue")
    gemfile = IO.read("#{project_path}/Gemfile")
    node_modules_file = IO.read("#{project_path}/package.json")

    expect(gemfile).to include('webpacker')
    expect(node_modules_file).to include("\"vue\"")
  end
end
