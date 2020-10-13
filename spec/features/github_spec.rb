require "spec_helper"

RSpec.describe "GitHub" do
  let(:org_name) { "platanus" }
  let(:repo_name) { PotassiumTestHelpers::APP_NAME.dasherize }
  let(:access_token) { "1234" }
  let(:pr_template_file) { IO.read("#{project_path}/.github/pull_request_template.md") }

  before do
    drop_dummy_database
    remove_project_directory
  end

  it "creates the github repository" do
    create_dummy_project(
      "github" => true,
      "github_private" => false,
      "github_has_org" => false,
      "github_name" => repo_name,
      "github_access_token" => access_token
    )

    expect(FakeOctokit).to have_created_repo(repo_name)
    expect(pr_template_file).to include('Contexto')
  end

  it "creates the private github repository" do
    create_dummy_project(
      "github" => true,
      "github_private" => true,
      "github_has_org" => false,
      "github_name" => repo_name,
      "github_access_token" => access_token
    )

    expect(FakeOctokit).to have_created_private_repo(repo_name)
    expect(pr_template_file).to include('Contexto')
  end

  it "creates the github repository for the organization" do
    create_dummy_project(
      "github" => true,
      "github_private" => false,
      "github_has_org" => true,
      "github_org" => org_name,
      "github_name" => repo_name,
      "github_access_token" => access_token
    )

    expect(FakeOctokit).to have_created_repo_for_org(repo_name, org_name)
    expect(pr_template_file).to include('Contexto')
  end

  it "creates the private github repository for the organization" do
    create_dummy_project(
      "github" => true,
      "github_private" => true,
      "github_has_org" => true,
      "github_org" => org_name,
      "github_name" => repo_name,
      "github_access_token" => access_token
    )

    expect(FakeOctokit).to have_created_private_repo_for_org(repo_name, org_name)
    expect(pr_template_file).to include('Contexto')
  end
end
