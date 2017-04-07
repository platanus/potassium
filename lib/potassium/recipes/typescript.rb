class Recipes::Typescript < Rails::AppBuilder
  APP_LAYOUT = "app/views/layouts/application.html.erb"

  def install
    add_typescript_support
  end

  def add_typescript_support
    gather_gem('webpack-rails')
    gather_gem('foreman')

    recipe = self

    after(:gem_install) do
      generate "webpack_rails:install"

      recipe.copy_templates

      run 'npm install -g typings' if Ask.confirm("Do you want me to install typings for you?")
      run 'typings install'
      run 'npm install'

      recipe.inject_js_links

      recipe.inject_ng_app
    end
  end

  def copy_templates
    remove_file 'webpack/application.js'
    copy_file '../assets/typescript/main.ts', 'webpack/main.ts'
    copy_file '../assets/typescript/vendor.ts', 'webpack/vendor.ts'

    remove_file 'config/webpack.config.js'
    copy_file '../assets/typescript/webpack.config.js', 'config/webpack.config.js'

    remove_file 'tsconfig.json'
    copy_file '../assets/typescript/tsconfig.json', 'tsconfig.json'

    remove_file 'typings.json'
    copy_file '../assets/typescript/typings.json', 'typings.json'

    remove_file 'package.json'
    copy_file '../assets/typescript/package.json', 'package.json'
  end

  def inject_ng_app
    unless File.readlines(APP_LAYOUT).grep(/ng-app/).any?
      gsub_file(APP_LAYOUT, /<body>/, '<body ng-app="app">')
    end
  end

  def inject_js_links
    line = "<%= csrf_meta_tags %>\n"
    insert_into_file "app/views/layouts/application.html.erb", before: line do
      <<-HERE.gsub(/^ {8}/, '')
      <%= javascript_include_tag *webpack_asset_paths('vendor', extension: 'js') %>
      <%= javascript_include_tag *webpack_asset_paths('main', extension: 'js') %>
      <%= stylesheet_link_tag *webpack_asset_paths('main', extension: 'css') %>
      HERE
    end
  end
end
