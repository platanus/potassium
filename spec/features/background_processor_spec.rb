require "spec_helper"

RSpec.describe "BackgroundProcessor" do
  context "working with delayed job" do
    before :all do
      drop_dummy_database
      remove_project_directory
      create_dummy_project("background_processor" => "delayed_job", "heroku" => true)
    end

    it "adds delayed_job gem to Gemfile" do
      gemfile_content = IO.read("#{project_path}/Gemfile")
      expect(gemfile_content).to include("gem 'delayed_job_active_record'")
    end

    it "adds queue_adapter to application.rb" do
      content = IO.read("#{project_path}/config/application.rb")
      expect(content).to include("config.active_job.queue_adapter = :delayed_job")
    end

    it "modifies Procfile" do
      content = IO.read("#{project_path}/Procfile")
      expect(content).to include("worker: bundle exec rails jobs:work")
    end

    it "overrides migration" do
      migration_name = Dir.entries("#{project_path}/db/migrate").last
      content = IO.read("#{project_path}/db/migrate/#{migration_name}")
      expect(content).to include("CreateDelayedJobs < ActiveRecord::Migration[4.2]")
    end
  end
end
