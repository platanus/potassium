recipe_name = ARGV.first

run_action(:recipe_loading) do
  install recipe_name.to_sym
  run_action(:gem_install) do
    run "bundle install" if build_gemfile
  end
end
