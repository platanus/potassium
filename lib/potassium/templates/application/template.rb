set :app_name, @app_name
set :titleized_app_name, get(:app_name).titleize
set :underscorized_app_name, get(:app_name).underscore

run_action(:cleaning) do
  clean_gemfile
  gather_gem('spring')
end

run_action(:asking) do
  eval_file "recipes/asks/database.rb"
  eval_file "recipes/asks/devise.rb"
  eval_file "recipes/asks/admin.rb"
  eval_file "recipes/asks/pundit.rb"
  eval_file "recipes/asks/i18n.rb"
  eval_file "recipes/asks/api.rb"
  eval_file "recipes/asks/paperclip.rb"
end

run_action(:recipe_loading) do
  eval_file "recipes/puma.rb"
  eval_file "recipes/database.rb"
  eval_file "recipes/readme.rb"
  eval_file "recipes/ruby.rb"
  eval_file "recipes/env.rb"
  eval_file "recipes/bower.rb"
  eval_file "recipes/editorconfig.rb"
  eval_file "recipes/aws_sdk.rb"
  eval_file "recipes/i18n.rb"
  eval_file "recipes/pry.rb"
  eval_file "recipes/devise.rb"
  eval_file "recipes/admin.rb"
  eval_file "recipes/angular_admin.rb"
  eval_file "recipes/pundit.rb"
  eval_file "recipes/testing.rb"
  eval_file "recipes/production.rb"
  eval_file "recipes/git.rb"
  eval_file "recipes/api.rb"
  eval_file "recipes/rack-cors.rb"
  eval_file "recipes/paperclip.rb"
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
