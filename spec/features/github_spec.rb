require "spec_helper"

RSpec.describe "GitHub" do
  let(:github_org) { "platanus" }
  let(:repo_name) { PotassiumTestHelpers::APP_NAME.dasherize }
  let(:pr_template_file) { IO.read("#{project_path}/.github/pull_request_template.md") }

  before do
    drop_dummy_database
    remove_project_directory
  end

  it "creates the github repository" do
    create_dummy_project(
      "github" => true,
      "github_private" => false,
      "github_org" => github_org,
      "github_name" => repo_name
    )

    expect(FakeGithub).to have_created_repo("#{github_org}/#{repo_name}")
    expect(pr_template_file).to include('Contexto')
  end

  it "creates the private github repository" do
    create_dummy_project(
      "github" => true,
      "github_private" => true,
      "github_org" => github_org,
      "github_name" => repo_name
    )

    expect(FakeGithub).to have_created_private_repo("#{github_org}/#{repo_name}")
    expect(pr_template_file).to include('Contexto')
  end
end
