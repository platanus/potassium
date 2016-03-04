require "spec_helper"
require "rubocop"

RSpec.describe "A new project" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    create_dummy_project("heroku" => true)
  end

  it "correctly runs continous integration" do
    expect { on_project { `bin/cibuild` } }.to_not output.to_stderr
  end
end
