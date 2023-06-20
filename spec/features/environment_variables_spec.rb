require 'spec_helper'

RSpec.describe 'EnvironmentVariables' do
  let(:environment_variables) { IO.read("#{project_path}/lib/environment_variables.rb") }

  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  it 'creates a .env.test file' do
    expect(File.exists?("#{project_path}/.env.test")).to eq(true)
  end

  it 'creates an EnvironmentVariables module with a constant and its method' do
    expect(environment_variables).to include(
      'module EnvironmentVariables',
      "APPLICATION_HOST = ENV.fetch('APPLICATION_HOST')",
      'def application_host'
    )
  end

  it 'requires module in application configuration' do
    expect(File.read("#{project_path}/config/application.rb"))
      .to include("require Rails.root.join('lib/environment_variables.rb')")
  end
end
