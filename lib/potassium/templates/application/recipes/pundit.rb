class Recipes::Pundit < Recipes::Base
  def ask
    if t.get(:authentication).present?
      use_pundit = t.answer(:pundit) { Ask.confirm("Do you want to use Pundit for authorization?") }
      t.set(:authorization, :pundit) if use_pundit
    end
  end

  def create
    add_pundit
  end

  def install
    t.set(:authorization, :pundit)
    t.set(:admin_mode, t.gem_exists?(/activeadmin/))
    add_pundit
  end

  private

  def add_pundit
    authorization_framework = {
      pundit: -> do
        t.gather_gem 'pundit'

        t.after(:gem_install) do
          application_controller = "app/controllers/application_controller.rb"
          gsub_file application_controller, "protect_from_forgery" do
            "include Pundit\n  protect_from_forgery"
          end
          generate "pundit:install"
        end

        if t.get(:admin_mode)
          t.after(:admin_install) do
            initializer = "config/initializers/active_admin.rb"
            gsub_file initializer, /# config\.authorization_adapter =[^\n]+\n/ do
              "config.authorization_adapter = ActiveAdmin::PunditAdapter\n"
            end

            template "assets/active_admin/pundit_page_policy.rb",
              "app/policies/active_admin/page_policy.rb"
            template "assets/active_admin/comment_policy.rb",
              "app/policies/active_admin/comment_policy.rb"
            template "assets/active_admin/admin_user_policy.rb",
              "app/policies/admin_user_policy.rb"
          end
        end
      end
    }

    if t.get(:authorization)
      instance_exec(&(authorization_framework[t.get(:authorization)] || -> {}))
    end
  end
end
