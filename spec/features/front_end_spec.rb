require "spec_helper"

RSpec.describe "Front end" do
  before :all do
    drop_dummy_database
    remove_project_directory
  end

  let(:application_css_path) { "#{project_path}/app/javascript/css/application.css" }
  let(:gemfile) { IO.read("#{project_path}/Gemfile") }
  let(:node_modules_file) { IO.read("#{project_path}/package.json") }
  let(:application_js_file) { IO.read("#{project_path}/app/javascript/packs/application.js") }
  let(:layout_file) { IO.read("#{project_path}/app/views/layouts/application.html.erb") }
  let(:application_css_file) { IO.read(application_css_path) }
  let(:tailwind_config_file) { IO.read("#{project_path}/tailwind.config.js") }
  let(:rails_css_file) { IO.read("#{project_path}/app/assets/stylesheets/application.css") }

  it "creates a project without a front end framework" do
    remove_project_directory
    create_dummy_project("front_end" => "None")
    expect(gemfile).to include('webpacker')
  end

  def expect_to_have_tailwind_compatibility_build
    expect(node_modules_file).to include("\"tailwindcss\": \"npm:@tailwindcss/postcss7-compat\"")
    expect(node_modules_file).to include("\"autoprefixer\": \"^9\"")
    expect(node_modules_file).to include("\"postcss\": \"^7\"")
  end

  context "with vue" do
    before(:all) do
      remove_project_directory
      create_dummy_project("front_end" => "vue")
    end

    it "creates a project with vue in compiler mode as frontend framework" do
      expect(gemfile).to include('webpacker')
      expect(node_modules_file).to include("\"vue\"")
      expect(application_js_file).to include('vue/dist/vue.esm')
      expect(application_js_file).to include("el: '#vue-app'")
      expect(layout_file).to include('id="vue-app"')
    end

    it "creates a project with only one js pack tag" do
      expect(layout_file.scan("javascript_pack_tag").length).to eq(1)
    end

    it "creates a vue project with client css" do
      expect(application_js_file).to include("import '../css/application.css';")
      expect(layout_file).to include("<%= stylesheet_pack_tag 'application' %>")
      expect(rails_css_file).not_to include('*= require_tree', '*= require_self')
    end

    it "creates a vue project with tailwindcss" do
      expect(node_modules_file).to include("\"tailwindcss\"")
      expect(application_css_file).to include(
        "@import 'tailwindcss/base';",
        "@import 'tailwindcss/components';"
      )
      expect(tailwind_config_file).to include('module.exports')
    end

    it 'includes correct packages for tailwind, postcss and autoprefixer compatibility build' do
      expect_to_have_tailwind_compatibility_build
    end

    context "with graphql" do
      before(:all) do
        remove_project_directory
        create_dummy_project("front_end" => "vue", "api" => "graphql")
      end

      it "creates a vue project with apollo" do
        expect(node_modules_file).to include("\"vue-apollo\"")
        expect(application_js_file).to include("import { ApolloClient } from 'apollo-client';")
        expect(application_js_file).to include("Vue.use(VueApollo)")
        expect(application_js_file).to include("apolloProvider,")
      end
    end
  end

  context "with angular" do
    before(:all) do
      remove_project_directory
      create_dummy_project("front_end" => "angular")
    end

    it "creates a project without vue as front end framework" do
      expect(gemfile).to include('webpacker')
      expect(node_modules_file).to include("\"@angular/core\"")
    end

    it "creates application_js_file for tailwind without vue" do
      expect(application_js_file).to include("import '../css/application.css';")
    end

    it 'includes correct packages for tailwind, postcss and autoprefixer compatibility build' do
      expect_to_have_tailwind_compatibility_build
    end
  end
end
