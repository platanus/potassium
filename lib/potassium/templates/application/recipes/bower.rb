copy_file 'assets/.bowerrc', '.bowerrc'
template 'assets/bower.json', 'bower.json'
application "config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')"

if get(:heroku)
  bower_buildpack_url = 'https://github.com/platanus/heroku-buildpack-bower.git'
  insert_point = 'https://github.com/platanus/heroku-buildpack-ruby-version.git'
  inject_into_file '.buildpacks', "#{bower_buildpack_url}\n", before: insert_point
end
