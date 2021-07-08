require "spec_helper"

RSpec.describe "Google Tag Manager" do
  before :all do
    remove_project_directory
    create_dummy_project('google_tag_manager' => true)
  end

  let(:gtm_head_file_path) do
    "#{project_path}/app/views/shared/_gtm_head.html.erb"
  end
  let(:gtm_body_file_path) do
    "#{project_path}/app/views/shared/_gtm_body.html.erb"
  end
  let(:content_security_policy_file_path) do
    "#{project_path}/config/initializers/content_security_policy.rb"
  end
  let(:application_layout_file) do
    IO.read("#{project_path}/app/views/layouts/application.html.erb")
  end
  let(:content_security_policy_file) do
    IO.read(content_security_policy_file_path)
  end

  it 'adds google tag manager script' do
    expect(File).to be_file(gtm_head_file_path)
    expect(File).to be_file(gtm_body_file_path)
    expect(application_layout_file).to include('shared/gtm_head')
    expect(application_layout_file).to include('shared/gtm_body')
  end

  it 'add content security policy' do
    expect(content_security_policy_file)
      .to include("\nRails.application.config.content_security_policy do |policy|")
  end
end
