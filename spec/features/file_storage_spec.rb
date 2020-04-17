require "spec_helper"

RSpec.describe "File Storage" do
  context "when selecting active_storage" do
    before :all do
      drop_dummy_database
      remove_project_directory
      create_dummy_project(storage: :active_storage)
    end

    it "adds the aws-sdk-s3 gem to Gemfile" do
      gemfile_content = IO.read("#{project_path}/Gemfile")
      expect(gemfile_content).to include("gem 'aws-sdk-s3'")
    end

    it "customizes config file" do
      content = IO.read("#{project_path}/config/storage.yml")
      expect(content).to include("bucket: <%= ENV['S3_BUCKET'] %>")
    end

    it "adds brief to README file" do
      content = IO.read("#{project_path}/README.md")
      expect(content).to include("Active Storage")
    end

    it "uses amazon on production env" do
      content = IO.read("#{project_path}/config/environments/production.rb")
      expect(content).to include("config.active_storage.service = :amazon")
    end

    it "adds S3 bucket ENV vars" do
      content = IO.read("#{project_path}/.env.development")
      expect(content).to include("S3_BUCKET=")
    end
  end

  context "when selecting shrine" do
    before :all do
      drop_dummy_database
      remove_project_directory
      create_dummy_project(storage: :shrine)
    end

    it "adds the aws-sdk-s3, shrine and marcel gems to Gemfile" do
      gemfile_content = IO.read("#{project_path}/Gemfile")
      expect(gemfile_content).to include("gem 'aws-sdk-s3'")
      expect(gemfile_content).to include("gem 'shrine'")
      expect(gemfile_content).to include("gem 'marcel'")
    end

    it "adds brief to README file" do
      content = IO.read("#{project_path}/README.md")
      expect(content).to include("Shrine")
    end

    it "adds shrine initializer" do
      expect(File.exist?("#{project_path}/config/initializers/shrine.rb")).to be true
    end

    it "adds base_uploader and image_uploader" do
      expect(File.exist?("#{project_path}/app/uploaders/base_uploader.rb")).to be true
      expect(File.exist?("#{project_path}/app/uploaders/image_uploader.rb")).to be true
    end

    it "adds S3 bucket ENV vars" do
      content = IO.read("#{project_path}/.env.development")
      expect(content).to include("S3_BUCKET=")
    end
  end
end
