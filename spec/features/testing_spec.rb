require "spec_helper"

RSpec.describe "Testing" do
  let(:gemfile_content) { IO.read("#{project_path}/Gemfile") }
  let(:rails_helper_content) { IO.read("#{project_path}/spec/rails_helper.rb") }
  let(:rspec_content) { IO.read("#{project_path}/.rspec") }

  let(:support_directories) do
    %w{
      custom_matchers
      shared_examples
      configurations
      helpers
    }
  end

  let(:conf_files) do
    %w{
      factory_bot_config.rb
      power_types_config.rb
      shoulda_matchers_config.rb
      devise_config.rb
      system_tests_config.rb
      faker_config.rb
    }
  end

  before(:all) do
    drop_dummy_database
    remove_project_directory
    create_dummy_project(devise: true)
  end

  it { expect(gemfile_content).to include('rspec-rails') }
  it { expect(gemfile_content).to include('factory_bot_rails') }
  it { expect(gemfile_content).to include('faker') }
  it { expect(gemfile_content).to include('guard-rspec') }
  it { expect(gemfile_content).to include('rspec-nc') }
  it { expect(gemfile_content).to include('shoulda-matchers') }
  it { expect(gemfile_content).to include('capybara') }
  it { expect(gemfile_content).to include('webdrivers') }

  it { expect(rails_helper_content).to include("require 'spec_helper'") }
  it { expect(rails_helper_content).to include("config.filter_run_when_matching :focus") }

  it { expect(rspec_content).to include("--require rails_helper") }
  it { expect(Dir.entries("#{project_path}/spec/support")).to include(*support_directories) }
  it { expect(Dir.entries("#{project_path}/spec/support/configurations")).to include(*conf_files) }

  it { expect(IO.read("#{project_path}/bin/rspec")).to include('path("rspec-core", "rspec")') }
  it { expect(IO.read("#{project_path}/Guardfile")).to include(':rspec, cmd: "bin/rspec"') }
  it { expect(IO.read("#{project_path}/bin/guard")).to include('path("guard", "guard")') }

  it { expect(IO.read("#{project_path}/README.md")).to include("To run unit test") }
end
