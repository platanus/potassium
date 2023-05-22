class Recipes::Admin < Rails::AppBuilder
  def ask
    if selected?(:authentication)
      admin_mode = answer(:admin) { Ask.confirm("Do you want to use ActiveAdmin?") }
      set(:admin_mode, admin_mode)
    end
  end

  def create
    if selected?(:admin_mode)
      if selected?(:authentication)
        add_active_admin
      else
        info "ActiveAdmin can't be installed because Devise isn't enabled."
      end
    end
  end

  def install
    devise = load_recipe(:devise)
    if devise.installed?
      add_active_admin
    else
      info "ActiveAdmin can't be installed because Devise isn't installed."
    end
  end

  def installed?
    gem_exists?(/activeadmin/)
  end

  def add_active_admin
    recipe = self
    gather_gem 'activeadmin', '~> 2.9'
    gather_gem 'activeadmin_addons', '~> 2.0.0.beta.0'
    add_readme_section :internal_dependencies, :active_admin
    after(:gem_install, wrap_in_action: :admin_install) do
      generate "active_admin:install --use_webpacker"
      run 'yarn add @activeadmin/activeadmin'
      line = "ActiveAdmin.setup do |config|"
      initializer = "config/initializers/active_admin.rb"
      gsub_file initializer, /(#{Regexp.escape(line)})/mi do |_match|
        <<~HERE
          class CustomFooter < ActiveAdmin::Component
            def build _arg
              super(id: "footer")
              para "Powered by Platanus"
            end
          end\n
          ActiveAdmin.setup do |config|
            config.view_factory.footer = CustomFooter
            meta_tags_options = { viewport: 'width=device-width, initial-scale=1' }
            config.meta_tags = meta_tags_options
            config.meta_tags_for_logged_out_pages = meta_tags_options
            config.comments = false
        HERE
      end

      generate "activeadmin_addons:install"

      run "yarn add arctic_admin @fortawesome/fontawesome-free"

      run 'rm -rf config/webpack/plugins'
      run 'rm app/javascript/packs/active_admin.js'
      run 'rm -rf app/javascript/packs/active_admin'
      run 'rm app/javascript/stylesheets/active_admin.scss'
      run 'rmdir app/javascript/packs'
      run 'rmdir app/javascript/stylesheets'
      run 'rmdir app/javascript'

      recipe.copy_frontend_files
      recipe.insert_vite_monkeypatch
    end
  end

  def copy_frontend_files
    copy_file '../assets/app/frontend/entrypoints/active_admin.js',
              'app/frontend/entrypoints/active_admin.js'
    copy_file '../assets/app/frontend/entrypoints/active_admin.scss',
              'app/frontend/entrypoints/active_admin.scss'
    copy_file '../assets/app/frontend/active_admin/jquery.js', 'app/frontend/active_admin/jquery.js'
  end

  def insert_vite_monkeypatch
    monkeypatch =
      <<~HERE
        module ActiveAdminViteJS
          def stylesheet_pack_tag(style, **options)
            style = 'active_admin.scss' if style == 'active_admin.css'
            vite_stylesheet_tag(style, **options)
          end

          def javascript_pack_tag(script, **options)
            vite_javascript_tag(script, **options)
          end
        end

        ActiveAdmin::Views::Pages::Base.include ActiveAdminViteJS
        ActiveSupport.on_load(:action_view) { include ActiveAdminViteJS }

      HERE
    insert_into_file "config/initializers/active_admin.rb", monkeypatch,
                     before: "ActiveAdmin.setup do |config|"
  end
end
