class Recipes::AngularAdmin < Rails::AppBuilder
  def ask
    if selected?(:admin_mode)
      angular_admin = answer(:"angular-admin") do
        Ask.confirm "Do you want Angular support for ActiveAdmin?"
      end
      set(:angular_admin, angular_admin)
    end
  end

  def create
    recipe = self
    if selected?(:angular_admin)
      after(:admin_install) do
        recipe.add_angular_admin
      end
    end
  end

  def install
    if dir_exist?("app/assets/javascripts/admin")
      info "ActiveAdmin is already installed"
    elsif gem_exists?(/activeadmin/)
      add_angular_admin
    else
      info "ActiveAdmin can't be installed because Active Admin isn't installed."
    end
  end

  def add_angular_admin
    copy_file '../assets/active_admin/init_activeadmin_angular.rb',
      'config/initializers/init_activeadmin_angular.rb'

    create_file 'app/assets/javascripts/admin_app.js', "angular.module('ActiveAdmin', []);"

    copy_file '../assets/active_admin/active_admin.js.coffee',
      'app/assets/javascripts/active_admin.js.coffee',
      force: true

    empty_directory 'app/assets/javascripts/admin'
    empty_directory 'app/assets/javascripts/admin/controllers'
    empty_directory 'app/assets/javascripts/admin/services'
    empty_directory 'app/assets/javascripts/admin/directives'

    create_file 'app/assets/javascripts/admin/controllers/.keep'
    create_file 'app/assets/javascripts/admin/services/.keep'
    create_file 'app/assets/javascripts/admin/directives/.keep'

    inside('.') do
      run('bower install angular --save')
    end
  end
end
