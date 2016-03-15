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
end
