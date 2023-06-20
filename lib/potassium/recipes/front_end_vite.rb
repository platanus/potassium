class Recipes::FrontEndVite < Rails::AppBuilder
  VUE_VERSION = Potassium::VUE_VERSION
  POSTCSS_VERSION = Potassium::POSTCSS_VERSION
  TAILWINDCSS_VERSION = Potassium::TAILWINDCSS_VERSION
  AUTOPREFIXER_VERSION = Potassium::AUTOPREFIXER_VERSION
  VUE_TEST_UTILS_VERSION = Potassium::VUE_TEST_UTILS_VERSION
  JSDOM_VERSION = Potassium::JSDOM_VERSION

  DEPENDENCIES = {
    tailwind: [
      "postcss@#{POSTCSS_VERSION}",
      "tailwindcss@#{TAILWINDCSS_VERSION}",
      "autoprefixer@#{AUTOPREFIXER_VERSION}",
      "sass"
    ],
    typescript: [
      "typescript"
    ],
    typescript_dev: [
      "@types/node"
    ],
    vue: [
      "vue@#{VUE_VERSION}"
    ],
    vue_dev: [
      "@tsconfig/node14",
      "@vitejs/plugin-vue",
      "@vue/tsconfig",
      "vue-tsc"
    ],
    vitest_dev: [
      "vitest",
      "@vue/test-utils@#{VUE_TEST_UTILS_VERSION}",
      "jsdom@#{JSDOM_VERSION}"
    ],
    api: [
      "axios",
      "humps"
    ],
    api_dev: [
      "@types/humps"
    ]
  }

  def installed?
    gem_exists?(/vite_rails/)
  end

  def create
    add_vite
  end

  def install
    add_vite
  end

  def add_vite
    gather_gem("vite_rails")
    recipe = self
    after(:gem_install, wrap_in_action: :vite_install) do
      run "yarn install"
      run "bundle exec vite install"
      recipe.install_packages
      recipe.setup_tailwind
      recipe.copy_config_files
      recipe.setup_vite
      recipe.copy_default_assets
      recipe.insert_vue_into_layout
      recipe.setup_api_client
      add_readme_header :vite
    end
  end

  def install_packages
    packages, dev_packages = DEPENDENCIES.partition { |k, _| !k.to_s.end_with?('_dev') }.map(&:to_h)

    run "yarn add #{packages.values.flatten.join(' ')}"
    run "yarn add --dev #{dev_packages.values.flatten.join(' ')}"
  end

  def setup_tailwind
    run "npx tailwindcss init -p"
  end

  def copy_config_files
    copy_file '../assets/vite.config.ts', 'vite.config.ts', force: true
    copy_file '../assets/tailwind.config.js', 'tailwind.config.js', force: true
    copy_file '../assets/tsconfig.json', 'tsconfig.json', force: true
    copy_file '../assets/tsconfig.config.json', 'tsconfig.config.json', force: true
  end

  def setup_vite
    add_vite_dev_ws_content_security_policy
    copy_dotenv_monkeypatch
  end

  def copy_default_assets
    copy_file '../assets/app/frontend/entrypoints/application.js',
              'app/frontend/entrypoints/application.js', force: true
    copy_file '../assets/app/frontend/css/application.css', 'app/frontend/css/application.css',
              force: true
    copy_file '../assets/app/frontend/components/app.vue', 'app/frontend/components/app.vue',
              force: true
    copy_file '../assets/app/frontend/types/vue.d.ts', 'app/frontend/types/vue.d.ts'
    copy_file '../assets/app/frontend/components/app.spec.ts',
              'app/frontend/components/app.spec.ts'
  end

  def insert_vue_into_layout
    layout_file = "app/views/layouts/application.html.erb"
    insert_into_file(
      layout_file,
      "<div id=\"vue-app\">\n      <app></app>\n      ",
      before: "<%= yield %>"
    )
    insert_into_file layout_file, "\n    </div>", after: "<%= yield %>"
  end

  def setup_api_client
    copy_file '../assets/app/frontend/api/index.ts', 'app/frontend/api/index.ts'
    copy_file '../assets/app/frontend/api/__mocks__/index.mock.ts',
              'app/frontend/api/__mocks__/index.mock.ts'
    copy_file '../assets/app/frontend/utils/case-converter.ts',
              'app/frontend/utils/case-converter.ts'
    copy_file '../assets/app/frontend/utils/csrf-token.ts',
              'app/frontend/utils/csrf-token.ts'
  end

  def add_vite_dev_ws_content_security_policy
    initializer = "config/initializers/content_security_policy.rb"
    line = "#    policy.style_src *policy.style_src, :unsafe_inline if Rails.env.development?"
    policy = <<~HERE.chomp
      # if Rails.env.development?
      #   policy.connect_src *policy.connect_src,
      #                     "ws://\#{ViteRuby.config.host_with_port}"
      # end
    HERE
    # check if policy already exists
    return if File.read(initializer).include?("policy.connect_src *policy.connect_src")

    inject_into_file initializer, after: line do
      policy
    end
  end

  def copy_dotenv_monkeypatch
    copy_file '../assets/lib/dotenv_monkeypatch.rb',
              'lib/dotenv_monkeypatch.rb', force: true
    insert_into_file(
      "config/application.rb",
      "\nrequire_relative '../lib/dotenv_monkeypatch'\n",
      after: "Bundler.require(*Rails.groups)"
    )
  end
end
