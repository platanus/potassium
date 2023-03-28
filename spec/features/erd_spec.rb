require "spec_helper"

RSpec.describe 'Erd' do
  let(:gemfile) { IO.read("#{project_path}/Gemfile") }
  let(:erd_task) { IO.read("#{project_path}/lib/tasks/auto_generate_erd_digram.rake") }

  before(:all) do
    remove_project_directory
    create_dummy_project
  end

  it { expect(gemfile).to include('rails_erd') }
  it { expect(erd_task).to include("Rake::Task['erd'].invoke") }
end
