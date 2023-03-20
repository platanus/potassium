require "spec_helper"

RSpec.describe "EditorConfig" do
  let(:conf_files) do
    %w{
      recommended-settings.json
      extensions.json
    }
  end

  before(:all) do
    drop_dummy_database
    remove_project_directory
    create_dummy_project
  end

  it { expect(File.exist?("#{project_path}/.editorconfig")).to be true }
  it { expect(Dir.entries("#{project_path}/.vscode")).to include(*conf_files) }
end
