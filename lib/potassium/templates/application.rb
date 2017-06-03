set :app_name, app_name
set :titleized_app_name, get(:app_name).titleize
set :underscorized_app_name, get(:app_name).underscore
set :dasherized_app_name, get(:app_name).dasherize

run_action(:after_create_rails) do
  rubocop_revision
end

run_action(:cleaning) do
  clean_gemfile
  gather_gem("spring")
end

run_action(:asking) do
  ask :database
  ask :devise
  ask :admin
  ask :front_end
  ask :commoner
  ask :angular_admin
  ask :mailer
  ask :background_processor
  ask :schedule
  ask :error_reporting
  ask :pundit
  ask :i18n
  ask :api
  ask :draper
  ask :paperclip
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
  create :yarn
  create :editorconfig
  create :aws_sdk
  create :mailer
  create :background_processor
  create :schedule
  create :i18n
  create :pry
  create :better_errors
  create :devise
  create :admin
  create :angular_admin
  create :seeds
  create :error_reporting
  create :pundit
  create :testing
  create :secrets
  create :git
  create :api
  create :draper
  create :power_types
  create :rack_cors
  create :paperclip
  create :tzinfo
  create :script
  create :github
  create :cleanup
  create :front_end
  create :commoner
end

info "Gathered enough information. Applying the template. Wait a minute."

run_action(:gem_install) do
  build_gemfile
  run "bundle install"
end

run_action(:database_creation) do
  run "bundle exec rails db:create db:migrate"
  run "RACK_ENV=test bundle exec rails db:create db:migrate"
end
