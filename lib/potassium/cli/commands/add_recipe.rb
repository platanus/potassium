module Potassium::CLI
  command :add_recipe do |c|
    c.action do |global_options, options, args|
      require "potassium/templates/application/recipe_generator"

      Potassium::RecipeGenerator.start
    end
  end
end
