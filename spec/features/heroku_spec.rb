require "spec_helper"

RSpec.describe "Heroku" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
  end

  it "creates a project for Heroku" do
    create_dummy_project("heroku" => true)
    app_name = PotassiumTestHelpers::APP_NAME.dasherize

    expect(FakeHeroku).to(
      have_gem_included(project_path, "rails_stdout_logging")
    )

    procfile_path = "#{project_path}/Procfile"
    procfile = IO.read(procfile_path)

    expect(procfile).to include("web: bundle exec puma -C ./config/puma.rb")

    buildpacks_path = "#{project_path}/.buildpacks"
    buildpacks = IO.read(buildpacks_path)

    expect(buildpacks).to include("https://github.com/heroku/heroku-buildpack-nodejs")
    expect(buildpacks).to include("https://github.com/platanus/heroku-buildpack-ruby-version.git")
    expect(buildpacks).to include("https://github.com/heroku/heroku-buildpack-ruby.git")
    expect(buildpacks).to(
      include("https://github.com/gunpowderlabs/buildpack-ruby-rake-deploy-tasks.git")
    )

    expect(FakeHeroku).to have_created_app_for("staging")
    expect(FakeHeroku).to have_created_app_for("production")

    expect(FakeHeroku).to have_configured_vars("staging", "SECRET_KEY_BASE")
    expect(FakeHeroku).to have_configured_vars("staging", "RACK_ENV")
    expect(FakeHeroku).to have_configured_vars("staging", "DEPLOY_TASKS")

    expect(FakeHeroku).to have_configured_vars("production", "SECRET_KEY_BASE")
    expect(FakeHeroku).to have_configured_vars("production", "RACK_ENV")
    expect(FakeHeroku).to have_configured_vars("production", "DEPLOY_TASKS")

    expect(FakeHeroku).to have_created_pipeline_for("staging")
    expect(FakeHeroku).to have_add_pipeline_for("production")

    bin_setup_path = "#{project_path}/bin/setup"
    bin_setup = IO.read(bin_setup_path)

    expect(bin_setup).to include("bin/setup_heroku")

    bin_setup_heroku_path = "#{project_path}/bin/setup_heroku"
    bin_setup_heroku = IO.read(bin_setup_heroku_path)

    expect(bin_setup_heroku).to include("heroku apps:info --app pl-#{app_name}-staging")
    expect(bin_setup_heroku).to include("heroku apps:info --app pl-#{app_name}-production")
    expect(bin_setup_heroku).to include("git config heroku.remote staging")
    expect(File.stat(bin_setup_path)).to be_executable
  end
end
