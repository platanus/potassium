require "spec_helper"
require 'yaml'

RSpec.describe "RedisProcessor" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("heroku" => true)
  end

  context "when installed" do
    it "adds redis-actionpack gem to Gemfile" do
      gemfile_content = IO.read("#{project_path}/Gemfile")
      expect(gemfile_content).to include("redis-actionpack")
    end

    it "adds ENV vars" do
      content = IO.read("#{project_path}/.env.development")
      expect(content).to include('REDIS_HOST=127.0.0.1')
      expect(content).to include(
        'REDIS_PORT=COMMAND_EXPAND(make services-port SERVICE=redis PORT=6379)'
      )
      expect(content).to include('REDIS_URL=redis://${REDIS_HOST}:${REDIS_PORT}/1')
    end

    it "adds redis.yml file" do
      content = IO.read("#{project_path}/config/redis.yml")
      expect(content).to include("REDIS_URL")
    end

    it 'adds redis to docker-compose' do
      compose_file = IO.read("#{project_path}/docker-compose.yml")
      compose_content = YAML.safe_load(compose_file, symbolize_names: true)

      expect(compose_content[:services]).to include(:redis)
    end
  end
end
