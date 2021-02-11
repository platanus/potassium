require "spec_helper"

RSpec.describe "Mailer" do
  let(:gemfile) { IO.read("#{project_path}/Gemfile") }
  let(:mailer_config) { IO.read("#{project_path}/config/mailer.rb") }
  let(:dev_config) { IO.read("#{project_path}/config/environments/development.rb") }
  let(:sidekiq_config) { IO.read("#{project_path}/config/sidekiq.yml") }

  before(:all) { drop_dummy_database }

  context "when selecting sendgrid as mailer" do
    before(:all) do
      remove_project_directory
      create_dummy_project("email_service" => "sendgrid")
    end

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

    it 'adds mailers queue to sidekiq config' do
      expect(sidekiq_config).to include("- mailers")
    end
  end

  context "when selecting aws_ses as mailer" do
    before(:all) do
      remove_project_directory
      create_dummy_project("email_service" => "aws_ses")
    end

    it { expect(gemfile).to include("aws-sdk-rails") }
    it { expect(gemfile).to include("letter_opener") }
    it { expect(mailer_config).to include("delivery_method = :aws_sdk") }
    it { expect(dev_config).to include("delivery_method = :letter_opener") }
  end
end
