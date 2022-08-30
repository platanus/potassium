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

  private

  def add_active_admin
    gather_gem 'activeadmin', '~> 2.9'
    gather_gem 'activeadmin_addons'
    add_readme_section :internal_dependencies, :active_admin
    after(:gem_install, wrap_in_action: :admin_install) do
      generate "active_admin:install --use_webpacker"
      run 'bin/yarn add @activeadmin/activeadmin'
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
        HERE
      end

      generate "activeadmin_addons:install"

      run "bin/yarn add arctic_admin @fortawesome/fontawesome-free"

      aa_style = "app/javascript/stylesheets/active_admin.scss"

      gsub_file(
        aa_style,
        "@import \"~@activeadmin/activeadmin/src/scss/mixins\";\n" +
        "@import \"~@activeadmin/activeadmin/src/scss/base\";",
        <<~HERE
          @import '~arctic_admin/src/scss/main';

          // Fix for sidebar when there are too many filters
          #sidebar {
            height: 100vh;
            top: 0;
            z-index: 10;
          }

          #sidebar::before {
            top: 200px !important;
          }

          #filters_sidebar_section {
            height: 100vh;
            overflow: auto;
          }

          // Fix for invisible datepicker calendar
          #ui-datepicker-div {
            z-index: 11 !important;
          }

          // Fix for backwards date range input
          #sidebar .sidebar_section .filter_date_range input:nth-child(2) {
            float: none;
          }

          #sidebar .sidebar_section .filter_date_range {
            display: flex;
            flex-flow: row wrap;
            justify-content: space-between
          }

          #sidebar .sidebar_section .filter_date_range label {
            width: 100%;
          }
        HERE
      )

      aa_js = "app/javascript/packs/active_admin.js"
      js_line = "import \"@activeadmin/activeadmin\";\n"

      gsub_file(
        aa_js,
        js_line,
        <<~HERE
          #{js_line}
          import '@fortawesome/fontawesome-free/css/all.css';
          import 'arctic_admin';
        HERE
      )

      run "mv app/javascript/packs/active_admin.js app/javascript/active_admin.js"
      gsub_file(
        "app/javascript/active_admin.js",
        'import "../stylesheets/active_admin";',
        'import "./stylesheets/active_admin.scss";'
      )

      run 'rm -rf config/webpack/plugins'
      run 'rm -rf app/javascript/packs/active_admin'
    end
  end
end
