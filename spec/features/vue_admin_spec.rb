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
    expect(initializer_file).to include("VueComponent")
    expect(initializer_file).to include("AUTO_BUILD_ELEMENTS")
  end

  it "adds layout tags to active admin layout initializer" do
    initializer_path = "#{project_path}/config/initializers/init_activeadmin_vue.rb"
    expect(File).to be_file(initializer_path)
  end

  it "adds admin_application pack to packs" do
    application_pack_path = "#{project_path}/app/javascript/packs/admin_application.js"
    expect(File).to be_file(application_pack_path)
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
    expect(js_package).to have_key("vue")
  end
end
