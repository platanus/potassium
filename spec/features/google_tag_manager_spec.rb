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
      .to include(content_security_policy_code)
  end

  def content_security_policy_code
    <<~HERE
      Rails.application.config.content_security_policy do |policy|
        if Rails.env.development?
          policy.connect_src :self, :https, 'http://localhost:3035', 'ws://localhost:3035'
          policy.script_src :self, :https, :unsafe_eval
        else
          policy.script_src :self, :https
          # google tag manager requires to enable unsafe inline:
          # https://developers.google.com/tag-manager/web/csp
          policy.connect_src :self, :https, 'https://www.google-analytics.com'
          policy.script_src :self,
            :https,
            :unsafe_inline,
            'https://www.googletagmanager.com',
            'https://www.google-analytics.com',
            'https://ssl.google-analytics.com'
          policy.img_src :self, :https, 'https://www.googletagmanager.com', 'https://www.google-analytics.com'
        end
      end
    HERE
  end
end
