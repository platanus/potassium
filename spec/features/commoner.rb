require "spec_helper"

RSpec.describe "commoner recipe" do
  context "when selected" do
    before(:all) do
      drop_dummy_database
      remove_project_directory
      create_dummy_project("commoner" => true, "front_end" => "None")
    end

    it "adds sprockets-commoner gem" do
      gemfile = File.read("#{project_path}/Gemfile")
      expect(gemfile).to include('sprockets-commoner')
    end

    it "creates a babelrc file" do
      expect(File.exist?("#{project_path}/.babelrc")).to be_truthy
    end

    it "installs babel as node dependency" do
      node_pkgs_file = File.read("#{project_path}/package.json")
      expect(node_pkgs_file).to include('"babel-core"')
    end
  end
end
