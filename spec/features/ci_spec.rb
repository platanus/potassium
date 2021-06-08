require "spec_helper"
require "rubocop"

RSpec.describe 'CI' do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  it "correctly bundles the config file" do
    yml_path = "#{project_path}/.circleci/config.yml"
    content = IO.read(yml_path)
    expect(File.exist?(yml_path)).to be true
    expect(content).to include('circleci/ruby', 'cache', 'rspec', 'reviewdog')
  end
end
