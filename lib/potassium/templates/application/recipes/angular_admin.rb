if get(:angular_admin)

  after(:admin_install) do
    copy_file 'assets/active_admin/init_activeadmin_angular.rb', 'config/initializers/init_activeadmin_angular.rb'

    create_file 'app/assets/javascripts/admin_app.js', "angular.module('ActiveAdmin', []);"

    copy_file 'assets/active_admin/active_admin.js.coffee', 'app/assets/javascripts/active_admin.js.coffee', force: true

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
