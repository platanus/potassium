class Recipes::FrontEnd < Rails::AppBuilder
  def ask
    frameworks = {
      vue: "Vue",
      angular: "Angular 2",
      none: "None"
    }

    framework = answer(:front_end) do
      frameworks.keys[
        Ask.list("Which front-end framework are you going to use?", frameworks.values)
      ]
    end
    set :front_end, framework.to_sym
  end

  def create
    recipe = self
    after(:gem_install) do
      value = get(:front_end)
      run "rails webpacker:install"
      run "rails webpacker:install:#{value}" unless [:none, :None].include? value.to_sym

      recipe.setup_vue if value == :vue
      recipe.add_responsive_meta_tag
      recipe.setup_tailwind
      add_readme_header :webpack
    end
  end

  def install
    ask
    create
  end

  def installed?
    package_file = 'package.json'
    return false unless file_exist?(package_file)
    package_content = read_file(package_file)
    package_content.include?("\"@angular/core\"") || package_content.include?("\"vue\"")
  end

  def setup_vue_with_compiler_build
    application_js = 'app/javascript/packs/application.js'
    remove_file "app/javascript/packs/hello_vue.js"
    create_file application_js, application_js_content, force: true

    layout_file = "app/views/layouts/application.html.erb"
    insert_into_file(
      layout_file,
      "<div id=\"vue-app\">\n      <app></app>\n      ",
      before: "<%= yield %>"
    )
    insert_into_file layout_file, "\n    </div>", after: "<%= yield %>"
  end

  def add_responsive_meta_tag
    tag = "\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n"
    layout_file = "app/views/layouts/application.html.erb"
    insert_into_file layout_file, tag, after: "<%= csrf_meta_tags %>"
  end

  def setup_tailwind
    run "bin/yarn add tailwindcss@#{Potassium::TAILWINDCSS}"
    specify_autoprefixer_postcss_compatibility_versions
    setup_client_css
    remove_server_css_requires
    setup_tailwind_requirements
  end

  def setup_jest
    run 'bin/yarn add jest vue-jest babel-jest @vue/test-utils jest-serializer-vue babel-core@^7.0.0-bridge.0 --dev'
    json_file = File.read(Pathname.new("package.json"))
    js_package = JSON.parse(json_file)
    js_package = js_package.merge(jest_config)
    json_string = JSON.pretty_generate(js_package)
    create_file 'package.json', json_string, force: true

    copy_file '../assets/app/javascript/app.spec.js', 'app/javascript/app.spec.js'
  end

  def setup_apollo
    run 'bin/yarn add vue-apollo graphql apollo-client apollo-link apollo-link-http apollo-cache-inmemory graphql-tag'

    inject_into_file(
      'app/javascript/packs/application.js',
      apollo_imports,
      after: "import App from '../app.vue';"
    )

    inject_into_file(
      'app/javascript/packs/application.js',
      apollo_loading,
      after: "import VueApollo from 'vue-apollo';"
    )
    inject_into_file(
      'app/javascript/packs/application.js',
      "\n    apolloProvider,",
      after: "components: { App },"
    )
  end

  def setup_vue
    setup_vue_with_compiler_build
    setup_jest
    if get(:api) == :graphql
      setup_apollo
    end
  end

  private

  def frameworks(framework)
    frameworks = {
      vue: "vue",
      angular: "angular",
      none: nil
    }
    frameworks[framework]
  end

  def apollo_imports
    <<~JS
      \n
      import { ApolloClient } from 'apollo-client';
      import { createHttpLink } from 'apollo-link-http';
      import { InMemoryCache } from 'apollo-cache-inmemory';
      import VueApollo from 'vue-apollo';
    JS
  end

  def apollo_loading
    <<~JS
      \n
      const httpLink = createHttpLink({
        uri: `${window.location.origin}/graphql`,
      })
      const cache = new InMemoryCache()
      const apolloClient = new ApolloClient({
        link: httpLink,
        cache,
      })

      Vue.use(VueApollo)
      const apolloProvider = new VueApollo({
        defaultClient: apolloClient,
      })
    JS
  end

  def specify_autoprefixer_postcss_compatibility_versions
    run 'bin/yarn -D add postcss@^7 autoprefixer@^9'
  end

  def setup_client_css
    application_css = 'app/javascript/css/application.css'
    create_file application_css, "", force: true

    stylesheet_pack_tag = "\n    <%= stylesheet_pack_tag 'application' %>\n  "
    layout_file = "app/views/layouts/application.html.erb"
    insert_into_file layout_file, stylesheet_pack_tag, before: "</head>"

    application_js = 'app/javascript/packs/application.js'
    if get(:front_end) != :vue
      create_file application_js, "import '../css/application.css';\n", force: true
    else
      insert_into_file(
        application_js,
        "\nimport '../css/application.css';",
        after: "import App from '../app.vue';"
      )
    end
  end

  def setup_tailwind_requirements
    application_css = 'app/javascript/css/application.css'
    insert_into_file application_css, tailwind_client_css

    tailwind_config = 'tailwind.config.js'
    create_file tailwind_config, tailwind_config_content, force: true

    postcss_file = 'postcss.config.js'
    insert_into_file postcss_file, postcss_require_tailwind, after: "plugins: [\n"
  end

  def remove_server_css_requires
    assets_css_file = 'app/assets/stylesheets/application.css'
    gsub_file(assets_css_file, " *= require_tree .\n *= require_self\n", "")
  end

  def application_js_content
    <<~JS
      import Vue from 'vue/dist/vue.esm';
      import App from '../app.vue';

      document.addEventListener('DOMContentLoaded', () => {
        const app = new Vue({
          el: '#vue-app',
          components: { App },
        });

        return app;
      });
    JS
  end

  def tailwind_client_css
    <<~CSS
      @import 'tailwindcss/base';
      @import 'tailwindcss/components';
      @import 'tailwindcss/utilities';
    CSS
  end

  def tailwind_config_content
    <<~JS
      /* eslint-disable no-undef */
      module.exports = {
        theme: {
          extend: {},
        },
        variants: {},
        plugins: [],
        purge: {
          enabled: process.env.NODE_ENV === 'production',
          content: [
            './app/**/*.html',
            './app/**/*.vue',
            './app/**/*.js',
            './app/**/*.erb',
          ],
        }
      };
    JS
  end

  def postcss_require_tailwind
    <<-JS.gsub(/^ {4}/, '  ')
      require('tailwindcss'),
      require('autoprefixer'),
    JS
  end

  def jest_config
    {
      "scripts": {
        "test": "jest",
        "test:watch": "jest --watch"
      },
      "jest": {
        "roots": [
          "app/javascript"
        ],
        "moduleDirectories": [
          "node_modules",
          "app/javascript"
        ],
        "moduleNameMapper": {
          "^@/(.*)$": "app/javascript/$1"
        },
        "moduleFileExtensions": [
          "js",
          "json",
          "vue"
        ],
        "transform": {
          "^.+\\.js$": "<rootDir>/node_modules/babel-jest",
          ".*\\.(vue)$": "<rootDir>/node_modules/vue-jest"
        },
        "snapshotSerializers": [
          "<rootDir>/node_modules/jest-serializer-vue"
        ],
        "testEnvironment": "jsdom"
      }
    }
  end
end
