class Recipes::Pundit < Rails::AppBuilder
  def ask
    if get(:authentication).present?
      use_pundit = answer(:pundit) { Ask.confirm("Do you want to use Pundit for authorization?") }
      set(:authorization, use_pundit)
    end
  end

  def create
    if selected?(:authorization)
      run_pundit_installer
      recipe = self

      if selected?(:admin_mode)
        after(:admin_install) do
          recipe.install_admin_pundit
        end
      end
    end
  end

  def install
    if gem_exists?(/pundit/)
      info "Pundit is already installed"
    else
      run_pundit_installer
      install_admin_pundit if gem_exists?(/activeadmin/)
    end
  end

  def run_pundit_installer
    gather_gem 'pundit'

    after(:gem_install) do
      application_controller = "app/controllers/application_controller.rb"
      gsub_file application_controller, "protect_from_forgery" do
        "include Pundit\n  protect_from_forgery"
      end
      generate "pundit:install"
    end
  end

  def install_admin_pundit
    initializer = "config/initializers/active_admin.rb"
    gsub_file initializer, /# config\.authorization_adapter =[^\n]+\n/ do
      "config.authorization_adapter = ActiveAdmin::PunditAdapter\n"
    end

    template "../assets/active_admin/pundit_page_policy.rb",
      "app/policies/active_admin/page_policy.rb"
    template "../assets/active_admin/comment_policy.rb",
      "app/policies/active_admin/comment_policy.rb"
    template "../assets/active_admin/admin_user_policy.rb",
      "app/policies/admin_user_policy.rb"
  end
end
