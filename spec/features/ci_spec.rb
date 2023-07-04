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

  it "adds brakeman to Gemfile" do
    content = IO.read("#{project_path}/Gemfile")
    expect(content).to include("brakeman")
  end

  it "correctly bundles the config file" do
    expect(ci_config).to include('cimg/ruby', 'cache', 'rspec', 'reviewdog', 'brakeman')
  end

  it "uses dasherized app name for repo analyzer" do
    expect(ci_config).to include(
      "repo_analyzer:analyze[platanus/#{PotassiumTestHelpers::APP_NAME.dasherize},project]"
    )
  end
end
