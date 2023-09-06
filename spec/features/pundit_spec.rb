require "spec_helper"

RSpec.describe "Pundit" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("pundit" => true, "devise" => true, "admin" => true)
  end

  it "adds the Pundit gem to Gemfile" do
    content = IO.read("#{project_path}/Gemfile")

    expect(content).to include("pundit")
  end

  it "setup active admin" do
    content = IO.read("#{project_path}/config/initializers/active_admin.rb")

    expect(content).to include("config.authorization_adapter = ActiveAdmin::PunditAdapter")
    expect(content).to include("config.pundit_default_policy = 'BackOffice::DefaultPolicy'")
    expect(content).to include("config.pundit_policy_namespace = :back_office")
  end

  it 'creates admin user factory' do
    content = IO.read("#{project_path}/spec/factories/admin_users.rb")

    expect(content).to include("email { Faker::Internet.unique.email }")
    expect(content).to include("password")
  end

  describe 'admin_user policy' do
    it "creates file" do
      content = IO.read("#{project_path}/app/policies/back_office/admin_user_policy.rb")

      expect(content).to include('class BackOffice::AdminUserPolicy')
    end

    it 'creates spec' do
      content = IO.read("#{project_path}/spec/policies/back_office/admin_user_policy_spec.rb")
      expect(content).to include('RSpec.describe BackOffice::AdminUserPolicy')
    end
  end

  describe 'default policy' do
    it 'creates file' do
      content = IO.read("#{project_path}/app/policies/back_office/default_policy.rb")

      expect(content).to include('class BackOffice::DefaultPolicy')
    end

    it 'creates spec' do
      content = IO.read("#{project_path}/spec/policies/back_office/default_policy_spec.rb")
      expect(content).to include('RSpec.describe BackOffice::DefaultPolicy')
    end
  end

  describe 'comment policy' do
    it 'creates file' do
      content = IO.read("#{project_path}/app/policies/back_office/active_admin/comment_policy.rb")

      expect(content).to include('class BackOffice::ActiveAdmin::CommentPolicy')
    end

    it 'creates spec' do
      content = IO.read(
        "#{project_path}/spec/policies/back_office/active_admin/comment_policy_spec.rb"
      )
      expect(content).to include('RSpec.describe BackOffice::ActiveAdmin::CommentPolicy')
    end
  end

  describe 'page policy' do
    it 'creates file' do
      content = IO.read("#{project_path}/app/policies/back_office/active_admin/page_policy.rb")

      expect(content).to include('class BackOffice::ActiveAdmin::PagePolicy')
    end

    it 'creates spec' do
      content = IO.read(
        "#{project_path}/spec/policies/back_office/active_admin/page_policy_spec.rb"
      )
      expect(content).to include('RSpec.describe BackOffice::ActiveAdmin::PagePolicy')
    end
  end

  it "modifies the README file" do
    readme = IO.read("#{project_path}/README.md")
    expect(readme).to include("from `BackOffice::DefaultPolicy`")
  end
end
