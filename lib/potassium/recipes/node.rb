require 'net/http'
require 'semantic'
require 'pry'
require 'json'

class Recipes::Node < Rails::AppBuilder
  def create
    info "Using node version LTS #{version}"
    create_file '.node-version', version, force: true
    json_file = File.read(Pathname.new("package.json"))
    js_package = JSON.parse(json_file)
    js_package["engines"] = { "node" => "#{version}.x" }
    json_string = JSON.pretty_generate(js_package)
    create_file 'package.json', json_string, force: true
  end

  private

  def version
    Potassium::NODE_VERSION
  end
end
