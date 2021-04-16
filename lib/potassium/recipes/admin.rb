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
    gather_gem 'activeadmin', '~> 2.6'
    gather_gem 'activeadmin_addons'
    add_readme_section :internal_dependencies, :active_admin
    after(:gem_install, wrap_in_action: :admin_install) do
      generate "active_admin:install --use_webpacker"
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
        HERE
      end

      generate "activeadmin_addons:install"
    end
  end
end
