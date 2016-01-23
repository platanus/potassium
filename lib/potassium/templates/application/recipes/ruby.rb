require 'net/http'
require 'semantic'

def latest
  Net::HTTP.get(URI.parse('http://ruby.platan.us/latest'))
rescue
  RUBY_VERSION
end

def version_alias
  version = latest
  Semantic::Version.new(version).instance_eval { "#{major}.#{minor}" }
end

say 'Getting platanus latest ruby version...', :green
say "Using ruby version #{version_alias}", :green
create_file '.ruby-version', version_alias
