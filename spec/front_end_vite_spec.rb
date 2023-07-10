require 'spec_helper'

RSpec.describe 'Front end' do
  before :all do
    drop_dummy_database
    remove_project_directory
    create_dummy_project('front_end_vite' => true)
  end

  def read_file(file_path)
    IO.read("#{project_path}/#{file_path}")
  end

  let(:gemfile) { read_file('Gemfile') }
  let(:application_file) { read_file('config/application.rb') }
  let(:node_modules_file) { read_file('package.json') }
  let(:application_js_file) { read_file('app/frontend/entrypoints/application.js') }
  let(:layout_file) { read_file('app/views/layouts/application.html.erb') }
  let(:csp_initializer) { read_file('config/initializers/content_security_policy.rb') }
  let(:application_css_file) { read_file('app/frontend/css/application.css') }
  let(:tailwind_config_file) { read_file('tailwind.config.js') }
  let(:rails_css_file) { read_file('app/assets/stylesheets/application.css') }
  let(:api_index_file) { read_file('app/frontend/api/index.ts') }
  let(:case_converter_file) { read_file('app/frontend/utils/case-converter.ts') }
  let(:csrf_token_file) { read_file('app/frontend/utils/csrf-token.ts') }
  let(:query_params_file) { read_file('app/frontend/utils/query-params.ts') }
  let(:mock_example_file) { read_file('app/frontend/api/__mocks__/index.mock.ts') }

  it 'creates a project with vite' do
    expect(gemfile).to include('vite_rails')
    expect(layout_file.scan('vite_client_tag').length).to eq(1)
    expect(layout_file.scan('vite_javascript_tag').length).to eq(2)
  end

  it 'creates a project with vue as frontend framework' do
    expect(node_modules_file).to include('"vue"')
    expect(application_js_file).to include('vue')
    expect(application_js_file).to include("app.mount('#vue-app')")
    expect(layout_file).to include('id="vue-app"')
  end

  it 'creates a vue project with client css' do
    expect(application_js_file).to include("import '../css/application.css';")
  end

  it 'creates a vue project with tailwindcss' do
    expect(node_modules_file).to include('"tailwindcss"')
    expect(application_css_file).to include(
      '@tailwind base;',
      '@tailwind components;'
    )
    expect(tailwind_config_file).to include('module.exports')
    expect(File.exists?(File.join(project_path, 'tailwind.config.js'))).to be(true)
    expect(File.exists?(File.join(project_path, 'postcss.config.js'))).to be(true)
  end

  it 'updates suggested csp policy' do
    expect(csp_initializer).to include('ViteRuby.config.host_with_port')
  end

  it 'includes correct packages for basic api client' do
    expect(node_modules_file).to include('"axios"')
    expect(node_modules_file).to include('"humps"')
    expect(node_modules_file).to include('"qs"')
  end

  it 'includes api client files' do
    expect(api_index_file).to include('axios.create')
    expect(case_converter_file).to include('humps')
    expect(csrf_token_file).to include('meta[name=csrf-token]')
    expect(query_params_file).to include('humps', 'qs')
  end

  it 'includes mock example' do
    expect(mock_example_file).to include('vi.fn()')
  end

  it 'includes the dotenv monkeypatch' do
    expect(application_file).to include("require_relative '../lib/dotenv_monkeypatch'")
    expect(File.exists?(File.join(project_path, 'lib/dotenv_monkeypatch.rb'))).to be(true)
  end
end
