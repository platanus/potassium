require 'net/http'
require 'semantic'

class Recipes::Ruby < Recipes::Base
  def create
    t.say 'Getting platanus latest ruby version...', :green
    t.say "Using ruby version #{version_alias}", :green
    t.create_file '.ruby-version', version_alias
  end

  private

  def latest
    Net::HTTP.get(URI.parse('http://ruby.platan.us/latest'))
  rescue
    RUBY_VERSION
  end

  def version_alias
    version = latest
    Semantic::Version.new(version).instance_eval { "#{major}.#{minor}" }
  end
end
