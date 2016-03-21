require "spec_helper"

RSpec.describe "GitHub" do
  before do
    drop_dummy_database
    remove_project_directory
  end

  it "create a the github repository" do
    create_dummy_project("github" => true)
    app_name = PotassiumTestHelpers::APP_NAME.dasherize

    expect(FakeGithub).to have_created_repo("platanus/#{app_name}")
  end

  it "create a the github private repository" do
    create_dummy_project("github" => true, "github-private" => true)
    app_name = PotassiumTestHelpers::APP_NAME.dasherize

    expect(FakeGithub).to have_created_private_repo("platanus/#{app_name}")
  end
end
