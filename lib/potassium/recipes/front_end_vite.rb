class Recipes::FrontEndVite < Rails::AppBuilder
  VUE_VERSION = Potassium::VUE_VERSION
  POSTCSS_VERSION = Potassium::POSTCSS_VERSION
  TAILWINDCSS_VERSION = Potassium::TAILWINDCSS_VERSION
  AUTOPREFIXER_VERSION = Potassium::AUTOPREFIXER_VERSION

  DEPENDENCIES = {
    tailwind: [
      "postcss@#{POSTCSS_VERSION}",
      "tailwindcss@#{TAILWINDCSS_VERSION}",
      "autoprefixer@#{AUTOPREFIXER_VERSION}",
      "sass",
      "eslint-plugin-tailwindcss"
    ],
    typescript: [
      "typescript",
      "@types/node"
    ],
    vue: [
      "vue@#{VUE_VERSION}"
    ],
    vue_dev: [
      "@vitejs/plugin-vue",
      "@vue/tsconfig",
      "vue-tsc"
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
      recipe.add_vite_dev_ws_content_security_policy
      recipe.copy_dotenv_monkeypatch
      recipe.install_tailwind
      recipe.install_typescript
      recipe.install_vue
      recipe.copy_vite_config
    end
  end

  def install_tailwind
    run "yarn add --dev #{DEPENDENCIES[:tailwind].join(' ')}"
    copy_file '../assets/tailwind.config.js', 'tailwind.config.js', force: true
  end

  def install_typescript
    run "yarn add --dev #{DEPENDENCIES[:typescript].join(' ')}"
    copy_file '../assets/tsconfig.json', 'tsconfig.json', force: true
    copy_file '../assets/tsconfig.config.json', 'tsconfig.config.json', force: true
  end

  def install_vue
    run "yarn add #{DEPENDENCIES[:vue].join(' ')}"
    run "yarn add --dev #{DEPENDENCIES[:vue_dev].join(' ')}"
  end

  def copy_vite_config
    copy_file '../assets/vite.config.ts', 'vite.config.ts', force: true
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
