copy_file 'assets/.bowerrc', '.bowerrc'
template 'assets/bower.json', 'bower.json'
application "config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')"
