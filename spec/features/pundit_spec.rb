require "spec_helper"

RSpec.describe "Pundit" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("pundit" => true, "devise" => true, "admin" => true)
  end

  it "adds the Pundit gem to Gemfile" do
    content = IO.read("#{project_path}/Gemfile")

    expect(content).to include("gem 'pundit'")
  end

  it "setup active admin" do
    content = IO.read("#{project_path}/config/initializers/active_admin.rb")

    expect(content).to include("config.authorization_adapter = ActiveAdmin::PunditAdapter")
    expect(content).to include("config.pundit_default_policy = 'BackOffice::DefaultPolicy'")
    expect(content).to include("config.pundit_policy_namespace = :back_office")
  end

  it "creates default policy" do
    content = IO.read("#{project_path}/app/policies/back_office/default_policy.rb")

    expect(content).to include("class BackOffice::DefaultPolicy")
  end

  it "modifies the README file" do
    readme = IO.read("#{project_path}/README.md")
    expect(readme).to include("from `BackOffice::DefaultPolicy`")
  end
end
