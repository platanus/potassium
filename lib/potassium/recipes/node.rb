require 'net/http'
require 'semantic'
require 'pry'
require 'json'

class Recipes::Node < Rails::AppBuilder
  def create
    info "Using node version #{version_alias}"
    create_file '.node-version', version_alias, force: true
    byebug
    json_file = File.read(Pathname.new("package.json"))
    js_package = JSON.parse(json_file)
    js_package["engines"] = {"node"=> "#{version}"}
    json_string = JSON.pretty_generate(js_package)
    create_file 'package.json', json_string, force: true
  end

  private

  def version
    Potassium::NODE_VERSION
  end

  def version_alias
    Semantic::Version.new(version).instance_eval { "#{major}.#{minor}" }
  end
end
