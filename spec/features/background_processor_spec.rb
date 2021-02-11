require "spec_helper"
require 'yaml'

RSpec.describe "BackgroundProcessor" do
  context "when working with sidekiq and no mailer" do
    before :all do
      drop_dummy_database
      remove_project_directory
      create_dummy_project("background_processor" => true, "heroku" => true)
    end

    it "adds sidekiq gem to Gemfile" do
      gemfile_content = IO.read("#{project_path}/Gemfile")
      expect(gemfile_content).to include("gem 'sidekiq'")
    end

    it "adds queue_adapter to application.rb" do
      content = IO.read("#{project_path}/config/application.rb")
      expect(content).to include("config.active_job.queue_adapter = :sidekiq")
    end

    it "adds async queue_adapter to development.rb" do
      content = IO.read("#{project_path}/config/environments/development.rb")
      expect(content).to include("config.active_job.queue_adapter = :async")
    end

    it "adds test queue_adapter to test.rb" do
      content = IO.read("#{project_path}/config/environments/test.rb")
      expect(content).to include("config.active_job.queue_adapter = :test")
    end

    it "modifies Procfile" do
      content = IO.read("#{project_path}/Procfile")
      expect(content).to include("worker: bundle exec sidekiq")
    end

    it "modifies README" do
      content = IO.read("#{project_path}/README.md")
      expect(content).to include("this project uses [Sidekiq]")
    end

    it "adds ENV vars" do
      content = IO.read("#{project_path}/.env.development")
      expect(content).to include("DB_POOL=25")
      expect(content).to include('REDIS_HOST=127.0.0.1')
      expect(content).to include('REDIS_PORT=$(make services-port SERVICE=redis PORT=6379)')
      expect(content).to include('REDIS_URL=redis://${REDIS_HOST}:${REDIS_PORT}/1')
    end

    it "adds sidekiq.rb file" do
      content = IO.read("#{project_path}/config/initializers/sidekiq.rb")
      expect(content).to include("require 'sidekiq'")
    end

    it "adds sidekiq.yml file with no mailer queue" do
      yml_path = "#{project_path}/config/sidekiq.yml"
      content = IO.read(yml_path)
      expect(File.exist?(yml_path)).to be true
      expect(content).not_to include("- mailers")
    end

    it "adds redis.yml file" do
      content = IO.read("#{project_path}/config/redis.yml")
      expect(content).to include("REDIS_URL")
    end

    it "mounts sidekiq app" do
      content = IO.read("#{project_path}/config/routes.rb")
      expect(content).to include("mount Sidekiq::Web => '/queue'")
    end

    it 'adds redis to docker-compose' do
      compose_file = IO.read("#{project_path}/docker-compose.yml")
      compose_content = YAML.safe_load(compose_file, symbolize_names: true)

      expect(compose_content[:services]).to include(:redis)
    end
  end

  context "when working with sidekiq and a mailer" do
    before :all do
      drop_dummy_database
      remove_project_directory
      create_dummy_project(
        "background_processor" => true, "heroku" => true, "email_service" => 'sendgrid'
      )
    end

    it "adds sidekiq.yml file with mailers queue" do
      content = IO.read("#{project_path}/config/sidekiq.yml")
      expect(content).to include("- mailers")
    end
  end
end
