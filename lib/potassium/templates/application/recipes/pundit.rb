authorization_framework = {
  pundit: ->{
    gather_gem 'pundit'

    after(:gem_install) do
      application_controller = "app/controllers/application_controller.rb"
      gsub_file application_controller, "protect_from_forgery" do
        "include Pundit\n  protect_from_forgery"
      end
      generate "pundit:install"
    end

    if get(:admin_mode)
      after(:admin_install) do
        initializer = "config/initializers/active_admin.rb"
        gsub_file initializer, /# config\.authorization_adapter =[^\n]+\n/ do
          "config.authorization_adapter = ActiveAdmin::PunditAdapter\n"
        end

        template "assets/active_admin/pundit_page_policy.rb", "app/policies/active_admin/page_policy.rb"
        template "assets/active_admin/comment_policy.rb", "app/policies/active_admin/comment_policy.rb"
        template "assets/active_admin/admin_user_policy.rb", "app/policies/admin_user_policy.rb"
      end
    end
  }
}

if get(:authorization)
  instance_exec(&(authorization_framework[get(:authorization)] || ->{ }))
end
