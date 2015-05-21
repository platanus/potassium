if get(:admin_mode)
  if equals?(:authentication, :devise)
    gather_gem 'activeadmin', github: 'activeadmin'
    gather_gem 'activeadmin_addons'

    after(:gem_install, :wrap_in_action => :admin_install) do
      generate "active_admin:install"

      line = "ActiveAdmin.setup do |config|"
      initializer = "config/initializers/active_admin.rb"
      gsub_file initializer, /(#{Regexp.escape(line)})/mi do |match|
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
    end
  else
    say "ActiveAdmin can't be installed because Devise isn't enabled.", :red
  end
end
