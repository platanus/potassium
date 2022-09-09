require "spec_helper"

RSpec.describe "Front end" do
  before :all do
    drop_dummy_database
    remove_project_directory
  end

  let(:application_css_path) { "#{project_path}/app/javascript/css/application.css" }
  let(:gemfile) { IO.read("#{project_path}/Gemfile") }
  let(:node_modules_file) { IO.read("#{project_path}/package.json") }
  let(:application_js_file) { IO.read("#{project_path}/app/javascript/application.js") }
  let(:layout_file) { IO.read("#{project_path}/app/views/layouts/application.html.erb") }
  let(:application_css_file) { IO.read(application_css_path) }
  let(:tailwind_config_file) { IO.read("#{project_path}/tailwind.config.js") }
  let(:rails_css_file) { IO.read("#{project_path}/app/assets/stylesheets/application.css") }

  it "creates a project without a front end framework" do
    remove_project_directory
    create_dummy_project("front_end" => "None")
    expect(gemfile).to include('shakapacker')
  end

  def expect_to_have_tailwind_package_versions
    expect(node_modules_file).to include("\"tailwindcss\": \"^3\"")
    expect(node_modules_file).to include("\"autoprefixer\": \"^10\"")
    expect(node_modules_file).to include("\"postcss\": \"^8\"")
  end

  context "with vue" do
    before(:all) do
      remove_project_directory
      create_dummy_project("front_end" => "vue")
    end

    it "creates a project with vue as frontend framework" do
      expect(gemfile).to include('shakapacker')
      expect(node_modules_file).to include("\"vue\"")
      expect(application_js_file).to include('vue')
      expect(application_js_file).to include("app.mount('#vue-app')")
      expect(layout_file).to include('id="vue-app"')
    end

    it "creates a project with only one js pack tag" do
      expect(layout_file.scan("javascript_pack_tag").length).to eq(1)
    end

    it "creates a vue project with client css" do
      expect(application_js_file).to include("import './css/application.css';")
      expect(layout_file).to include("<%= stylesheet_pack_tag 'application' %>")
      expect(rails_css_file).not_to include('*= require_tree', '*= require_self')
    end

    it "creates a vue project with tailwindcss" do
      expect(node_modules_file).to include("\"tailwindcss\"")
      expect(application_css_file).to include(
        "@tailwind base;",
        "@tailwind components;"
      )
      expect(tailwind_config_file).to include('module.exports')
    end

    it 'includes correct packages for tailwind, postcss and autoprefixer compatibility build' do
      expect_to_have_tailwind_package_versions
    end

    it 'includes correct version of vue-loader in package' do
      expect(node_modules_file).to include("\"vue-loader\": \"#{Potassium::VUE_LOADER_VERSION}\"")
    end

    it 'includes correct packages for basic api client' do
      expect(node_modules_file).to include("\"axios\"")
      expect(node_modules_file).to include("\"humps\"")
    end
  end
end
