recipe = ARGV.first

# Consider all the recipe's questions as true
def selected?(_key, _val = nil)
  true
end

run_action(:recipe_loading) do
  load_recipe(recipe)
end

run_action(:gem_install) do
  build_gemfile
  run "bundle install"
end

# Ensure all the recipe's callbacks are executed
get(:callbacks).each do |_name, callbacks|
  puts "Processing #{name} callbacks"
  callbacks.each do |_event, event_callbacks|
    event_callbacks.each { |callback| instance_exec(&callback) }
  end
end
