require "spec_helper"

RSpec.describe "Coverage" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  it "adds simplecov related gems to Gemfile" do
    content = IO.read("#{project_path}/Gemfile")
    expect(content).to include("gem 'simplecov'")
    expect(content).to include("gem 'simplecov_linter_formatter'")
    expect(content).to include("gem 'simplecov_text_formatter'")
  end

  it "requires simplecov config file before rails" do
    content = IO.read("#{project_path}/spec/rails_helper.rb")
    expect(content).to include("ENV['RACK_ENV'] ||= 'test'\nrequire 'simplecov_config'")
  end

  it "adds simplecov config file" do
    content = IO.read("#{project_path}/spec/simplecov_config.rb")
    expect(content).to include("SimpleCov.start 'rails'")
  end
end
