class Recipes::Yarn < Rails::AppBuilder
  def create
    template '../assets/package.json', 'package.json'
    template '../assets/bin/update.erb', 'bin/update', force: true
    application "config.assets.paths << Rails.root.join('node_modules')"
    append_to_file ".gitignore", "node_modules/\n"

    if get(:heroku)
      node_buildpack_url = 'https://github.com/heroku/heroku-buildpack-nodejs'
      insert_point = 'https://github.com/platanus/heroku-buildpack-ruby-version.git'
      inject_into_file '.buildpacks', "#{node_buildpack_url}\n", before: insert_point
    end
  end
end
