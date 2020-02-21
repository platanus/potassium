require "spec_helper"

RSpec.describe "Node" do
  let(:version) { "12" }

  before(:all) do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  it "adds engine with node version to package.json" do
    package_json_path = "#{project_path}/package.json"
    expect(File).to be_file(package_json_path)
    json_file = File.read(package_json_path)
    js_package = JSON.parse(json_file)
    expect(js_package).to have_key("engines")
    expect(js_package["engines"]).to have_key("node")
    expect(js_package["engines"]["node"]).to eq("#{version}.x")
  end

  it "adds .node-version with correct version" do
    node_version_path = "#{project_path}/.node-version"
    expect(File).to be_file(node_version_path)
    node_version_file = File.read(node_version_path)
    expect(node_version_file).to eq(version)
  end
end
