class Recipes::Pundit < Recipes::Base
  def ask
    if t.get(:authentication).present?
      use_pundit = t.answer(:pundit) { Ask.confirm("Do you want to use Pundit for authorization?") }
      t.set(:authorization, use_pundit)
    end
  end

  def create
    if t.selected?(:authorization)
      run_pundit_installer
      recipe = self

      if t.selected?(:admin_mode)
        t.after(:admin_install) do
          recipe.install_admin_pundit
        end
      end
    end
  end

  def install
    run_pundit_installer
    install_admin_pundit if t.gem_exists?(/activeadmin/)
    true
  end

  def run_pundit_installer
    t.gather_gem 'pundit'

    t.after(:gem_install) do
      application_controller = "app/controllers/application_controller.rb"
      gsub_file application_controller, "protect_from_forgery" do
        "include Pundit\n  protect_from_forgery"
      end
      generate "pundit:install"
    end
  end

  def install_admin_pundit
    initializer = "config/initializers/active_admin.rb"
    t.gsub_file initializer, /# config\.authorization_adapter =[^\n]+\n/ do
      "config.authorization_adapter = ActiveAdmin::PunditAdapter\n"
    end

    t.template "../assets/active_admin/pundit_page_policy.rb",
      "app/policies/active_admin/page_policy.rb"
    t.template "../assets/active_admin/comment_policy.rb",
      "app/policies/active_admin/comment_policy.rb"
    t.template "../assets/active_admin/admin_user_policy.rb",
      "app/policies/admin_user_policy.rb"
  end
end
