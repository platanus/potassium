class Recipes::Bower < Recipes::Base
  def create
    t.copy_file '../assets/.bowerrc', '.bowerrc'
    t.template '../assets/bower.json', 'bower.json'
    t.application "config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')"

    if t.get(:heroku)
      bower_buildpack_url = 'https://github.com/platanus/heroku-buildpack-bower.git'
      insert_point = 'https://github.com/platanus/heroku-buildpack-ruby-version.git'
      t.inject_into_file '.buildpacks', "#{bower_buildpack_url}\n", before: insert_point
    end
  end
end
