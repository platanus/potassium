require 'net/http'
require 'semantic'
require 'json'

class Recipes::Node < Rails::AppBuilder
  NODE_VERSION = Potassium::NODE_VERSION

  def create
    info "Using node version LTS #{NODE_VERSION}"
    create_file '.node-version', NODE_VERSION, force: true
    after(:webpacker_install) do
      json_file = File.read(Pathname.new("package.json"))
      js_package = JSON.parse(json_file)
      js_package["engines"] = { "node" => "#{NODE_VERSION}.x" }
      json_string = JSON.pretty_generate(js_package)
      create_file 'package.json', json_string, force: true
    end
  end
end
