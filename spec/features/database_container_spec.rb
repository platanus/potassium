require "spec_helper"

RSpec.describe "DatabaseContainer" do
  before(:all) do
    drop_dummy_database
  end

  before do
    remove_project_directory
    create_dummy_project("database" => database)
  end

  after do
    `docker-compose -f #{project_path}/docker-compose.yml down`
  end

  [:postgresql, :mysql].each do |db_type|
    context "when database is #{db_type}" do
      let!(:database) { db_type }

      it "creates a #{db_type} database container" do
        env_file = IO.read("#{project_path}/.env.development")
        compose_file = IO.read("#{project_path}/docker-compose.yml")
        compose_content = YAML.safe_load(compose_file, symbolize_names: true)
        setup_file = IO.read("#{project_path}/bin/setup")

        service_name = compose_content[:services].keys.first
        db_port = compose_content[:services][service_name][:ports].first

        expect(env_file)
          .to include("DB_PORT=$(make services-port SERVICE=#{service_name} PORT=#{db_port})")
        expect(env_file).to include("DB_HOST=127.0.0.1")
        expect(File.exist?("#{project_path}/Makefile")).to be true
        expect(setup_file).to include("make services-up")
      end
    end
  end
end
