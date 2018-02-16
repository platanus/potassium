require "spec_helper"

RSpec.describe "Kaminari" do
  before do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("kaminari" => true)
  end

  it "adds the Kaminari gem to Gemfile" do
    gemfile_content = IO.read("#{project_path}/Gemfile")
    expect(gemfile_content).to include("gem 'kaminari'")
  end

  it "adds the Kaminari brief to README file" do
    readme = IO.read("#{project_path}/README.md")
    expect(readme).to include("kaminari")
  end

  it "adds Kaminari_config file to initializers folder" do
    kaminari_config = IO.read("#{project_path}/config/initializers/kaminari_config.rb")
    expect(kaminari_config).to include("Kaminari.configure")
  end
end
