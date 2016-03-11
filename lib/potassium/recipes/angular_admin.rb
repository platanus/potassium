class Recipes::AngularAdmin < Recipes::Base
  def ask
    if t.selected?(:admin_mode)
      angular_admin = t.answer(:"angular-admin") do
        Ask.confirm "Do you want Angular support for ActiveAdmin?"
      end
      t.set(:angular_admin, angular_admin)
    end
  end

  def create
    recipe = self
    if t.selected?(:angular_admin)
      t.after(:admin_install) do
        recipe.add_angular_admin
      end
    end
  end

  def install
    if t.gem_exists?(/activeadmin/)
      add_angular_admin
    else
      t.error "ActiveAdmin can't be installed because Active Admin isn't installed."
    end
  end

  def add_angular_admin
    t.copy_file '../assets/active_admin/init_activeadmin_angular.rb',
      'config/initializers/init_activeadmin_angular.rb'

    t.create_file 'app/assets/javascripts/admin_app.js', "angular.module('ActiveAdmin', []);"

    t.copy_file '../assets/active_admin/active_admin.js.coffee',
      'app/assets/javascripts/active_admin.js.coffee',
      force: true

    t.empty_directory 'app/assets/javascripts/admin'
    t.empty_directory 'app/assets/javascripts/admin/controllers'
    t.empty_directory 'app/assets/javascripts/admin/services'
    t.empty_directory 'app/assets/javascripts/admin/directives'

    t.create_file 'app/assets/javascripts/admin/controllers/.keep'
    t.create_file 'app/assets/javascripts/admin/services/.keep'
    t.create_file 'app/assets/javascripts/admin/directives/.keep'

    t.inside('.') do
      t.run('bower install angular --save')
    end
  end
end
