require "spec_helper"

RSpec.describe "Coverage" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  it "adds simplecov related gems to Gemfile" do
    content = IO.read("#{project_path}/Gemfile")
    expect(content).to include("simplecov")
    expect(content).to include("simplecov_linter_formatter")
    expect(content).to include("simplecov_text_formatter")
  end

  it "requires simplecov config file before rails" do
    content = IO.read("#{project_path}/spec/rails_helper.rb")
    expect(content).to include("ENV['RACK_ENV'] ||= 'test'\nrequire 'simplecov_config'")
  end

  it "adds simplecov config file" do
    content = IO.read("#{project_path}/spec/simplecov_config.rb")
    expect(content).to include("SimpleCov.start 'rails'")
  end

  context "with vue" do
    let(:node_modules_file) { IO.read("#{project_path}/package.json") }
    let(:vite_config) { IO.read("#{project_path}/vite.config.ts") }

    before(:all) do
      remove_project_directory
      create_dummy_project("front_end_vite" => true)
    end

    it "adds vitest coverage configuration" do
      expect(vite_config).to include("provider: 'c8',")
    end

    it "adds jest text formatter package" do
      expect(node_modules_file).to include('jest-text-formatter')
    end
  end
end
