require "spec_helper"

RSpec.describe "Front end" do
  before(:all) { drop_dummy_database }
  before(:each) { remove_project_directory }

  let(:gemfile) { IO.read("#{project_path}/Gemfile") }
  let(:node_modules_file) { IO.read("#{project_path}/package.json") }
  let(:application_js_file) { IO.read("#{project_path}/app/javascript/packs/application.js") }
  let(:layout_file) { IO.read("#{project_path}/app/views/layouts/application.html.erb") }

  it "creates a project wihtout a front end framework" do
    create_dummy_project("front_end" => "None")
    expect(gemfile).not_to include('webpacker')
  end

  it "creates a project wihtout vue as front end framework" do
    create_dummy_project("front_end" => "angular")

    expect(gemfile).to include('webpacker')
    expect(node_modules_file).to include("\"@angular/core\"")
  end

  it "creates a project wiht vue in compiler mode as frontend framework" do
    create_dummy_project("front_end" => "vue")

    expect(gemfile).to include('webpacker')
    expect(node_modules_file).to include("\"vue\"")
    expect(application_js_file).to include('vue/dist/vue.esm')
    expect(application_js_file).to include("el: '#vue-app'")
    expect(layout_file).to include('id="vue-app"')
  end
end
