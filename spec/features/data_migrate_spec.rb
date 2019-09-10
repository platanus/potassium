require "spec_helper"

RSpec.describe 'DataMigrate' do
  let(:gemfile) { IO.read("#{project_path}/Gemfile") }
  let(:annotate_task) { IO.read("#{project_path}/lib/tasks/auto_annotate_models.rake") }

  before(:all) do
    remove_project_directory
    create_dummy_project
  end

  it { expect(gemfile).to include("data_migrate") }
  it { expect(annotate_task).to include("data_migrate_tasks") }
end
