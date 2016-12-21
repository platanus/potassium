set :app_name, app_name
set :titleized_app_name, get(:app_name).titleize
set :underscorized_app_name, get(:app_name).underscore
set :dasherized_app_name, get(:app_name).dasherize

run_action(:cleaning) do
  clean_gemfile
  gather_gem("spring")
end

run_action(:asking) do
  ask :database
  ask :devise
  ask :admin
  ask :angular_admin
  ask :delayed_job
  ask :pundit
  ask :i18n
  ask :api
  ask :paperclip
  ask :mailer
  ask :heroku
  ask :github
end

run_action(:recipe_loading) do
  create :readme
  create :heroku
  create :ci
  create :style
  create :puma
  create :database
  create :annotate
  create :ruby
  create :env
  create :bower
  create :editorconfig
  create :aws_sdk
  create :mailer
  create :i18n
  create :pry
  create :devise
  create :admin
  create :angular_admin
  create :delayed_job
  create :pundit
  create :testing
  create :secrets
  create :git
  create :api
  create :rack_cors
  create :paperclip
  create :tzinfo
  create :script
  create :github
  create :cleanup
end

info "Gathered enough information. Applying the template. Wait a minute."

run_action(:gem_install) do
  build_gemfile
  run "bundle install"
end

run_action(:database_creation) do
  run "rake db:create db:migrate"
  run "RACK_ENV=test rake db:create db:migrate"
end
