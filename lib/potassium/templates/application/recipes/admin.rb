class Recipes::Admin < Recipes::Base
  def ask
    if t.selected?(:authentication, :devise)
      admin_mode = t.answer(:admin) { Ask.confirm("Do you want to use ActiveAdmin?") }
      if admin_mode
        angular_admin = t.answer(:"angular-admin") do
          Ask.confirm "Do you want Angular support for ActiveAdmin?"
        end
        t.set(:angular_admin, angular_admin)
      end

      t.set(:admin_mode, admin_mode)
    end
  end

  def create
    if t.selected?(:admin_mode)
      if t.selected?(:authentication, :devise)
        add_active_admin
      else
        t.info "ActiveAdmin can't be installed because Devise isn't enabled."
      end
    end
  end

  def install
    if t.gem_exists?(/devise/)
      add_active_admin
    else
      t.info "ActiveAdmin can't be installed because Devise isn't installed."
      false
    end
  end

  private

  def add_active_admin
    t.gather_gem 'activeadmin', github: 'activeadmin'
    t.gather_gem 'activeadmin_addons'
    t.gather_gem 'active_skin'

    t.after(:gem_install, wrap_in_action: :admin_install) do
      generate "active_admin:install"
      line = "ActiveAdmin.setup do |config|"
      initializer = "config/initializers/active_admin.rb"
      gsub_file initializer, /(#{Regexp.escape(line)})/mi do |_match|
        <<-HERE.gsub(/^ {11}/, '')
           class CustomFooter < ActiveAdmin::Component
             def build
               super(id: "footer")
               para "Powered by Platanus"
             end
           end\n
           ActiveAdmin.setup do |config|
             config.view_factory.footer = CustomFooter
           HERE
      end

      line = "@import \"active_admin/base\";"
      style = "app/assets/stylesheets/active_admin.css.scss"
      style = File.exist?(style) ? style : "app/assets/stylesheets/active_admin.scss"

      gsub_file style, /(#{Regexp.escape(line)})/mi do |_match|
        <<-HERE.gsub(/^ {11}/, '')
           #{line}
           $skinActiveColor: #001CEE;
           $skinHeaderBck: #002744;
           $panelHeaderBck: #002744;
           //$skinLogo: $skinHeaderBck image-url("logo_admin.png") no-repeat center center;

           @import "active_skin";
           HERE
      end

      generate "activeadmin_addons:install"
    end
  end
end
