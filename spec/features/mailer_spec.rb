require "spec_helper"

RSpec.describe "Mailer" do
  let(:gemfile) { IO.read("#{project_path}/Gemfile") }
  let(:env) { IO.read("#{project_path}/.env.development") }
  let(:dev_config) { IO.read("#{project_path}/config/environments/development.rb") }
  let(:prod_config) { IO.read("#{project_path}/config/environments/production.rb") }
  let(:asset_host_dev) do
    <<~RUBY
      config.action_mailer.asset_host = "http://\#{ENV.fetch('APPLICATION_HOST')}"
    RUBY
  end
  let(:asset_host_prod) do
    <<~RUBY
      config.action_mailer.asset_host = "https://\#{ENV.fetch('APPLICATION_HOST')}"
    RUBY
  end
  let(:mailer_config_text) do
    <<~RUBY
      require Rails.root.join("config/mailer")
    RUBY
  end

  before(:all) { drop_dummy_database }

  describe 'with mailer' do
    let(:mailer_config) { IO.read("#{project_path}/config/mailer.rb") }
    let(:sidekiq_config) { IO.read("#{project_path}/config/sidekiq.yml") }

    context "when selecting sendgrid as mailer" do
      before(:all) do
        remove_project_directory
        create_dummy_project("email_service" => "sendgrid")
      end

      it_behaves_like "name"
      it { expect(gemfile).to include("send_grid_mailer") }

      it "adds configuration to mailer.rb" do
        expect(mailer_config).to include("delivery_method = :sendgrid")
        expect(mailer_config).to include("sendgrid_settings = {")
        expect(mailer_config).to include("api_key: ENV['SENDGRID_API_KEY']")
      end

      it "adds configuration to development.rb" do
        expect(dev_config).to include("delivery_method = :sendgrid_dev")
        expect(dev_config).to include("sendgrid_dev_settings = {")
        expect(dev_config).to include("api_key: ENV['SENDGRID_API_KEY']")
      end

      it "adds configuration to production" do
        expect(prod_config).to include(mailer_config_text)
        expect(prod_config).to include(asset_host_prod)
      end
    end

    context "when selecting aws_ses as mailer" do
      before(:all) do
        remove_project_directory
        create_dummy_project("email_service" => "aws_ses")
      end

      it_behaves_like "name"
      it { expect(gemfile).to include("aws-sdk-rails") }
      it { expect(gemfile).to include("letter_opener") }
      it { expect(mailer_config).to include("delivery_method = :aws_sdk") }
      it { expect(dev_config).to include("delivery_method = :letter_opener") }
    end

    context "when selecting a mailer and sidekiq" do
      before :all do
        drop_dummy_database
        remove_project_directory
        create_dummy_project(
          "background_processor" => true, "email_service" => 'sendgrid'
        )
      end

      it { expect(sidekiq_config).to include("- mailers") }
    end
  end

  context "when there is no mailer" do
    before(:all) do
      remove_project_directory
      create_dummy_project
    end

    it { expect(gemfile).not_to include("letter_opener") }
    it { expect(File.exists?("#{project_path}/config/mailer.rb")).to eq(false) }
    it { expect(env).not_to include("EMAIL_RECIPIENTS") }

    it "adds configuration to development" do
      expect(dev_config).not_to include(asset_host_dev)
      expect(dev_config).not_to include("delivery_method")
    end

    it "adds configuration to production" do
      expect(prod_config).not_to include(mailer_config_text)
      expect(prod_config).not_to include(asset_host_prod)
    end
  end
end
