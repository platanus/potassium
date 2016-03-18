set :app_name, app_name
set :titleized_app_name, get(:app_name).titleize
set :underscorized_app_name, get(:app_name).underscore
set :dasherized_app_name, get(:app_name).dasherize
recipe_name = ARGV.first

run_action(:recipe_loading) do
  install recipe_name.to_sym
  run_action(:gem_install) do
    run "bundle install" if build_gemfile
  end
end
