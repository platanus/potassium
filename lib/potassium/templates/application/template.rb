database = load_recipe "database"
devise = load_recipe "devise"
paperclip = load_recipe "paperclip"
admin = load_recipe "admin"
delayed_job = load_recipe "delayed_job"
pundit = load_recipe "pundit"
i18n = load_recipe "i18n"
api = load_recipe "api"
heroku = load_recipe "heroku"
puma = load_recipe "puma"
readme = load_recipe "readme"
ruby = load_recipe "ruby"
env = load_recipe "env"
bower = load_recipe "bower"
editorconfig = load_recipe "editorconfig"
aws_sdk = load_recipe "aws_sdk"
pry = load_recipe "pry"
angular_admin = load_recipe "angular_admin"
testing = load_recipe "testing"
production = load_recipe "production"
staging = load_recipe "staging"
secrets = load_recipe "secrets"
git = load_recipe "git"
rack_cors = load_recipe "rack_cors"
ci = load_recipe "ci"
cleanup = load_recipe "cleanup"

set :app_name, @app_name
set :titleized_app_name, get(:app_name).titleize
set :underscorized_app_name, get(:app_name).underscore
set :dasherized_app_name, get(:app_name).dasherize

run_action(:cleaning) do
  clean_gemfile
  gather_gem("spring")
end

run_action(:asking) do
  database.ask
  devise.ask
  admin.ask
  delayed_job.ask
  pundit.ask
  i18n.ask
  api.ask
  paperclip.ask
  heroku.ask
end

run_action(:recipe_loading) do
  heroku.create
  puma.create
  database.create
  readme.create
  ruby.create
  env.create
  bower.create
  editorconfig.create
  aws_sdk.create
  i18n.create
  pry.create
  devise.create
  admin.create
  angular_admin.create
  delayed_job.create
  pundit.create
  testing.create
  production.create
  staging.create
  secrets.create
  git.create
  api.create
  rack_cors.create
  ci.create
  paperclip.create
  cleanup.create
end

say "Gathered enough information. Applying the template. Wait a minute.", :green

run_action(:gem_install) do
  build_gemfile
  run "bundle install"
end

run_action(:database_creation) do
  run "rake db:create db:migrate"
  run "RAILS_ENV=test rake db:create db:migrate"
end
