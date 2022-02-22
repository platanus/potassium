require "spec_helper"
require "pry"
RSpec.describe "VueAdmin" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    create_dummy_project(:vue_admin => true, "admin" => true, "devise" => true)
  end

  it "adds component integration to active admin initializer" do
    admin_initializer_path = "#{project_path}/config/initializers/active_admin.rb"
    expect(File).to be_file(admin_initializer_path)
    initializer_file = File.read(admin_initializer_path)
    expect(initializer_file).to include("AUTO_BUILD_ELEMENTS")
  end

  it "adds vue_component to library" do
    vue_component_lib_path = "#{project_path}/lib/vue_component.rb"
    expect(File).to be_file(vue_component_lib_path)
    vue_component_lib = File.read(vue_component_lib_path)
    expect(vue_component_lib).to include("VueComponent")
  end

  it "adds admin_component to vue components" do
    application_pack_path = "#{project_path}/app/javascript/components/admin-component.vue"
    expect(File).to be_file(application_pack_path)
  end

  it "installs vue to project" do
    package_json_path = "#{project_path}/package.json"
    expect(File).to be_file(package_json_path)
    json_file = File.read(package_json_path)
    js_package = JSON.parse(json_file)
    expect(js_package).to have_key("dependencies")
    expect(js_package["dependencies"]).to have_key("vue")
  end
end
