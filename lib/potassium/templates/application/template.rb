Dir.entries(File.expand_path('../recipes', __FILE__)).each do |file_name|
  if file_name.end_with?('.rb')
    recipe_name = file_name.gsub('.rb', '')
    singleton_class.send(:attr_reader, "#{recipe_name}_recipe")
    instance_variable_set("@#{recipe_name}_recipe", load_recipe(recipe_name))
  end
end

set :app_name, @app_name
set :titleized_app_name, get(:app_name).titleize
set :underscorized_app_name, get(:app_name).underscore
set :dasherized_app_name, get(:app_name).dasherize

run_action(:cleaning) do
  clean_gemfile
  gather_gem("spring")
end

run_action(:asking) do
  database_recipe.ask
  devise_recipe.ask
  admin_recipe.ask
  delayed_job_recipe.ask
  pundit_recipe.ask
  i18n_recipe.ask
  api_recipe.ask
  paperclip_recipe.ask
  heroku_recipe.ask
end

run_action(:recipe_loading) do
  heroku_recipe.create
  puma_recipe.create
  database_recipe.create
  readme_recipe.create
  ruby_recipe.create
  env_recipe.create
  bower_recipe.create
  editorconfig_recipe.create
  aws_sdk_recipe.create
  i18n_recipe.create
  pry_recipe.create
  devise_recipe.create
  admin_recipe.create
  angular_admin_recipe.create
  delayed_job_recipe.create
  pundit_recipe.create
  testing_recipe.create
  production_recipe.create
  staging_recipe.create
  secrets_recipe.create
  git_recipe.create
  api_recipe.create
  rack_cors_recipe.create
  ci_recipe.create
  paperclip_recipe.create
  cleanup_recipe.create
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
