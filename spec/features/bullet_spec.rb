require "spec_helper"

RSpec.describe "Bullet" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  context "with all the bullet config" do
    let(:dev_config) { IO.read("#{project_path}/config/environments/development.rb") }

    it { expect(dev_config).to include("config.after_initialize do") }
    it { expect(dev_config).to include("Bullet.enable = true") }
    it { expect(dev_config).to include("Bullet.alert = true") }
    it { expect(dev_config).to include("Bullet.bullet_logger = true") }
    it { expect(dev_config).to include("Bullet.console = true") }
    it { expect(dev_config).to include("Bullet.rails_logger = true") }
    it { expect(dev_config).to include("Bullet.add_footer = true") }
  end

  context "with bullet application job config" do
    let(:application_job) { IO.read("#{project_path}/app/jobs/application_job.rb") }

    it 'adds bullet configuration to application_job.rb' do
      expect(application_job).to include("  include Bullet::ActiveJob if Rails.env.development?\n")
    end
  end
end
