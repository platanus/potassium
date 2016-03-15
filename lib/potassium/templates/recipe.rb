recipe_name = ARGV.first

run_action(:recipe_loading) do
  recipe = load_recipe(recipe_name)
  if recipe
    recipe.install
    run_action(:gem_install) do
      run "bundle install" if build_gemfile
    end
  end
end
