set :app_name, app_name
set :node_version, node_version
set :titleized_app_name, get(:app_name).titleize
set :underscorized_app_name, get(:app_name).underscore
set :dasherized_app_name, get(:app_name).dasherize

run_action(:cleaning) do
  clean_gemfile
end

run_action(:asking) do
  ask :database
  ask :devise
  ask :admin
  ask :google_tag_manager
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
  ask :github
end

run_action(:recipe_loading) do
  create :rails
  create :spring
  create :readme
  create :heroku
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
  create :redis
  create :background_processor
  create :schedule
  create :i18n
  create :pry
  create :better_errors
  create :monitoring
  create :devise
  create :seeds
  create :error_reporting
  create :testing
  create :pundit
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
  create :ci
  create :cleanup
  create :google_tag_manager
  create :mjml
  create :bullet
  create :front_end_vite
  create :admin
  create :vue_admin
  create :environment_variables
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

run_action(:rubocop_revision) do
  run_rubocop
end
