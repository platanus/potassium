recipe_name = ARGV.first

run_action(:recipe_loading) do
  recipe = load_recipe(recipe_name)
  if recipe
    if recipe.install
      run_action(:gem_install) do
        build_gemfile
        run "bundle install"
      end
    end
  end
end
