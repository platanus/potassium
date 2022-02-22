class Recipes::FrontEnd < Rails::AppBuilder
  VUE_LOADER_VERSION = Potassium::VUE_LOADER_VERSION
  VUE_VERSION = Potassium::VUE_VERSION
  VUE_TEST_UTILS_VERSION = Potassium::VUE_TEST_UTILS_VERSION
  POSTCSS_VERSION = Potassium::POSTCSS_VERSION
  TAILWINDCSS_VERSION = Potassium::TAILWINDCSS_VERSION
  AUTOPREFIXER_VERSION = Potassium::AUTOPREFIXER_VERSION
  VUE_JEST_VERSION = Potassium::VUE_JEST_VERSION

  def ask
    frameworks = {
      vue: "Vue",
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
    gather_gem('shakapacker', '~> 6.0')
    recipe = self
    after(:gem_install, wrap_in_action: :webpacker_install) do
      run "rails webpacker:install"
    end
    after(:webpacker_install) do
      value = get(:front_end)
      recipe.copy_webpack_rules
      recipe.setup_typescript
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
    package_content.include?("\"vue\"")
  end

  def copy_webpack_rules
    copy_file '../assets/config/webpack/webpack.config.js',
              'config/webpack/webpack.config.js',
              force: true
    copy_file '../assets/config/webpack/rules/index.js', 'config/webpack/rules/index.js'
    copy_file '../assets/config/webpack/rules/css.js', 'config/webpack/rules/css.js'
    copy_file '../assets/config/webpack/rules/vue.js', 'config/webpack/rules/vue.js'
    copy_file '../assets/config/webpack/rules/jquery.js', 'config/webpack/rules/jquery.js'
    copy_file '../assets/config/webpack/rules/typescript.js', 'config/webpack/rules/typescript.js'
  end

  def setup_typescript
    run "bin/yarn add typescript fork-ts-checker-webpack-plugin ts-loader @types/node"
    copy_file '../assets/tsconfig.json', 'tsconfig.json'
  end

  def setup_vue_with_compiler_build
    application_ts = 'app/javascript/application.ts'
    create_file application_ts, application_ts_content, force: true

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
    run "bin/yarn add css-loader style-loader mini-css-extract-plugin @types/tailwindcss "\
      "css-minimizer-webpack-plugin postcss@#{POSTCSS_VERSION} postcss-loader "\
      "tailwindcss@#{TAILWINDCSS_VERSION} autoprefixer@#{AUTOPREFIXER_VERSION} sass sass-loader"
    run "npx tailwindcss init -p"
    setup_client_css
    remove_server_css_requires
    setup_tailwind_requirements
  end

  def setup_jest
    run "bin/yarn add jest @vue/vue3-jest@#{VUE_JEST_VERSION} babel-jest "\
    "@vue/test-utils@#{VUE_TEST_UTILS_VERSION} ts-jest"
    json_file = File.read(Pathname.new("package.json"))
    js_package = JSON.parse(json_file)
    js_package = js_package.merge(jest_config)
    json_string = JSON.pretty_generate(js_package)
    create_file 'package.json', json_string, force: true

    copy_file '../assets/app/javascript/components/app.spec.ts',
              'app/javascript/components/app.spec.ts'
  end

  def setup_apollo
    run 'bin/yarn add vue-apollo graphql apollo-client apollo-link apollo-link-http apollo-cache-inmemory graphql-tag'

    inject_into_file(
      'app/javascript/application.ts',
      apollo_imports,
      after: "import App from '../app.vue';"
    )

    inject_into_file(
      'app/javascript/application.ts',
      apollo_loading,
      after: "import VueApollo from 'vue-apollo';"
    )
    inject_into_file(
      'app/javascript/application.ts',
      "\n    apolloProvider,",
      after: "components: { App },"
    )
  end

  def setup_vue
    run "bin/yarn add vue@#{VUE_VERSION} vue-loader@#{VUE_LOADER_VERSION} "\
        "babel-preset-typescript-vue3"
    gsub_file(
      'config/webpack/webpack.config.js',
      ' merge(typescriptConfig, cssConfig, jQueryConfig, webpackConfig);',
      ' merge(vueConfig, typescriptConfig, cssConfig, jQueryConfig, webpackConfig);'
    )
    copy_file '../assets/app/javascript/components/app.vue', 'app/javascript/components/app.vue'
    copy_file '../assets/app/javascript/types/vue.d.ts', 'app/javascript/types/vue.d.ts'
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

  def setup_client_css
    application_css = 'app/javascript/css/application.css'
    create_file application_css, "", force: true

    stylesheet_pack_tag = "\n    <%= stylesheet_pack_tag 'application' %>\n  "
    layout_file = "app/views/layouts/application.html.erb"
    insert_into_file layout_file, stylesheet_pack_tag, before: "</head>"

    application_ts = 'app/javascript/application.ts'
    if get(:front_end) != :vue
      create_file application_ts, "import './css/application.css';\n", force: true
    else
      insert_into_file(
        application_ts,
        "\nimport './css/application.css';",
        after: "import App from './components/app.vue';"
      )
    end
  end

  def setup_tailwind_requirements
    application_css = 'app/javascript/css/application.css'
    insert_into_file application_css, tailwind_client_css

    tailwind_config = 'tailwind.config.js'
    create_file tailwind_config, tailwind_config_content, force: true
  end

  def remove_server_css_requires
    assets_css_file = 'app/assets/stylesheets/application.css'
    gsub_file(assets_css_file, " *= require_tree .\n *= require_self\n", "")
  end

  def application_ts_content
    <<~JS
      import { createApp } from 'vue';
      import App from './components/app.vue';

      document.addEventListener('DOMContentLoaded', () => {
        const app = createApp({
          components: { App },
        });
        app.mount('#vue-app');

        return app;
      });
    JS
  end

  def tailwind_client_css
    <<~CSS
      @tailwind base;
      @tailwind components;
      @tailwind utilities;
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
        content: [
          './app/**/*.html',
          './app/**/*.vue',
          './app/**/*.js',
          './app/**/*.erb',
        ],
      };
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
          "ts",
          "json",
          "vue"
        ],
        "transform": {
          "^.+\\.ts$": "ts-jest",
          ".*\\.(vue)$": "@vue/vue3-jest"
        },
        "testEnvironment": "jsdom"
      }
    }
  end
end
