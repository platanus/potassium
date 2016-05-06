require 'net/http'
require 'semantic'

class Recipes::Ruby < Rails::AppBuilder
  def create
    info "Using ruby version #{version_alias}"
    create_file '.ruby-version', version_alias
  end

  private

  def version
    Potassium::RUBY_VERSION
  end

  def version_alias
    Semantic::Version.new(version).instance_eval { "#{major}.#{minor}" }
  end
end
