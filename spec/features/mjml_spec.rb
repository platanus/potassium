require "spec_helper"

RSpec.describe "Mjml" do
  let(:gemfile) { IO.read("#{project_path}/Gemfile") }
  let(:mailer_config) { IO.read("#{project_path}/config/mailer.rb") }
  let(:dev_config) { IO.read("#{project_path}/config/environments/development.rb") }
  let(:sidekiq_config) { IO.read("#{project_path}/config/sidekiq.yml") }
  let(:yarn_lock) { IO.read("#{project_path}/yarn.lock") }

  before(:all) { drop_dummy_database }

  context "when selecting a mailer" do
    before(:all) do
      remove_project_directory
      create_dummy_project("email_service" => "sendgrid")
    end

    it 'adds gems and packages' do
      expect(yarn_lock).to include("mjml")
      expect(gemfile).to include("mjml-rails")
    end

    it 'creates example mailer' do
      expect(File.exists?("#{project_path}/app/views/layouts/default_mail.html.mjml")).to eq(true)
      expect(File.exists?("#{project_path}/app/mailers/example_mailer.rb")).to eq(true)
      expect(File.exists?("#{project_path}/app/views/example_mailer/example_mail.html.mjml"))
        .to eq(true)
      expect(File.exists?("#{project_path}/public/mails/platanus-logo.png")).to eq(true)
    end
  end

  context "when there is no mailer selected" do
    before(:all) do
      remove_project_directory
      create_dummy_project
    end

    it 'adds gems and packages' do
      expect(yarn_lock).not_to include("mjml")
      expect(gemfile).not_to include("mjml-rails")
    end

    it 'creates example mailer' do
      expect(File.exists?("#{project_path}/app/views/layouts/default_mail.html.mjml"))
        .not_to eq(true)
      expect(File.exists?("#{project_path}/app/mailers/example_mailer.rb"))
        .not_to eq(true)
      expect(File.exists?("#{project_path}/app/views/example_mailer/example_mail.html.mjml"))
        .not_to eq(true)
      expect(File.exists?("#{project_path}/public/mails/platanus-logo.png")).not_to eq(true)
    end
  end
end
