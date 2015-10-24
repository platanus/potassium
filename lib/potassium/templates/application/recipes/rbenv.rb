require 'net/http'
require 'semantic'
require 'pry'

def latest
  printf 'Getting platanus latest ruby version...'
  Net::HTTP.get(URI.parse('http://ruby.platan.us/latest'))
rescue
  puts " not found, using #{RUBY_VERSION}"
  RUBY_VERSION
end

def version_alias
  version = latest

  puts "using #{version}"
  Semantic::Version.new(version).instance_eval { "#{major}.#{minor}" }
end

create_file '.rbenv-vars'
template 'assets/.rbenv-vars.example', '.rbenv-vars.example'
run "cp .rbenv-vars.example .rbenv-vars"
create_file '.ruby-version', version_alias
