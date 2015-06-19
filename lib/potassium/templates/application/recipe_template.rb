recipe = ARGV.first

def selected?(key, val = nil)
  true
end

run_action(:recipe_loading) do
  eval_file "recipes/#{recipe}.rb"
end

run_action(:gem_install) do
  build_gemfile
  run "bundle install"
end
