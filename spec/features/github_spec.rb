require "spec_helper"

RSpec.describe "GitHub" do
  before do
    drop_dummy_database
    remove_project_directory
  end

  it "create a the github repository" do
    create_dummy_project("github" => true)

    expect(FakeGithub).to have_created_repo('platanus/dummy-app')
  end

  it "create a the github private repository" do
    create_dummy_project("github" => true, "github-private" => true)

    expect(FakeGithub).to have_created_private_repo('platanus/dummy-app')
  end
end
