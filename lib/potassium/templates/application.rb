set :app_name, app_name
set :node_version, node_version
set :titleized_app_name, get(:app_name).titleize
set :underscorized_app_name, get(:app_name).underscore
set :dasherized_app_name, get(:app_name).dasherize

run_action(:after_create_rails) do
  rubocop_revision
end

run_action(:cleaning) do
  clean_gemfile
end

run_action(:add_utils) do
  gather_gem("enumerize")
end

run_action(:asking) do
  ask :database
  ask :devise
  ask :admin
  ask :google_tag_manager
  ask :front_end
  ask :vue_admin
  ask :mailer
  ask :background_processor
  ask :schedule
  ask :error_reporting
  ask :pundit
  ask :i18n
  ask :api
  ask :draper
  ask :file_storage
  ask :heroku
  ask :review_apps
  ask :github
end

run_action(:recipe_loading) do
  create :rails
  create :spring
  create :readme
  create :heroku
  create :ci
  create :style
  create :puma
  create :env
  create :database_container
  create :database
  create :annotate
  create :data_migrate
  create :listen
  create :node
  create :ruby
  create :yarn
  create :editorconfig
  create :mailer
  create :background_processor
  create :schedule
  create :i18n
  create :pry
  create :better_errors
  create :monitoring
  create :devise
  create :seeds
  create :error_reporting
  create :pundit
  create :testing
  create :coverage
  create :secrets
  create :api
  create :draper
  create :power_types
  create :rack_cors
  create :file_storage
  create :tzinfo
  create :script
  create :github
  create :review_apps
  create :cleanup
  create :front_end
  create :admin
  create :vue_admin
  create :google_tag_manager
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
