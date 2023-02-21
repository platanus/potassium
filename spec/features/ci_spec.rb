require "spec_helper"
require "rubocop"

RSpec.describe 'CI' do
  let(:ci_config) do
    yml_path = "#{project_path}/.circleci/config.yml"
    IO.read(yml_path)
  end

  before(:all) do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  it "correctly bundles the config file" do
    expect(ci_config).to include('cimg/ruby', 'cache', 'rspec', 'reviewdog')
  end

  it "adds repo analyzer config" do
    expect(ci_config).to include('bin/rake "repo_analyzer:analyze[platanus/dummy_app]"')
  end
end
