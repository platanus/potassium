require "spec_helper"

RSpec.describe "I18n" do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("locale" => "es-CL")
  end

  it "adds the Clockwork gem to Gemfile" do
    content = IO.read("#{project_path}/Gemfile")

    expect(content).to include("rails-i18n")
  end

  it "configures application.rb" do
    application_config = IO.read("#{project_path}/config/application.rb")
    production_config = IO.read("#{project_path}/config/environments/production.rb")

    expect(application_config).to include("config.i18n.default_locale = 'es-CL'")
    expect(application_config).to include("config.i18n.fallbacks = [:es, :en]")
    expect(production_config).not_to include("config.i18n.fallbacks = true")
  end
end
