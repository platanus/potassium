require "spec_helper"
require "rubocop"

RSpec.describe "A new project" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  it "is correctly bundled" do
    expect { on_project { `bundle exec rails -v` } }.to_not output.to_stderr
  end

  it "is a valid rubocop project" do
    on_project do
      expect(run_rubocop).to eq(true)
    end
  end

  it "configures rubocop" do
    rubocop_config_file = IO.read("#{project_path}/.rubocop.yml")

    expect(rubocop_config_file).to include("inherit_from")
    expect(rubocop_config_file).to include("style_guides/platanus/ruby.yml")
    expect(rubocop_config_file).to include(".ruby_style.yml")
  end

  it "set custom ruby style file placeholder" do
    expect(File).to exist("#{project_path}/.ruby_style.yml")
  end

  it "configures hound" do
    hound_config_file = IO.read("#{project_path}/.hound.yml")

    expect(hound_config_file).to include("config_file: .ruby_style.yml")
  end

  it "configures postgresql" do
    database_config_file = IO.read("#{project_path}/config/database.yml")
    gemfile = IO.read("#{project_path}/Gemfile")

    expect(database_config_file).to include(%{adapter: postgresql})
    expect(gemfile).to include %{gem 'pg'}
  end

  it "configures the correct ruby version" do
    ruby_version_file = IO.read("#{project_path}/.ruby-version")

    expect(ruby_version_file).to eq("2.3")
  end
end
