require 'levenshtein'
require 'inquirer'
require 'potassium/generators/recipe'
require 'potassium/recipe'

module Potassium::CLI
  desc "Installs a new feature or library"
  command :install do |c|
    c.switch "force",
      desc: "Whether to force the recipe installation",
      default_value: false
    c.action do |_global_options, options, args|
      if args.first.nil?
        index = Ask.list('Select a recipe to install', recipe_name_list)
        ARGV << recipe_name_list[index]
        template = Potassium::RecipeGenerator
        template.cli_options = options
        template.start
      elsif recipe_exists?(args)
        template = Potassium::RecipeGenerator
        template.cli_options = options
        template.start
      else
        guess = guess_recipe_name(args)
        puts "Oops! Sorry, that recipe doesn't exist. Were you looking for this?: #{guess}"
      end
    end
  end

  def self.recipe_exists?(args)
    recipe_name_list.include?(args.first)
  end

  def self.guess_recipe_name(args)
    if recipe_exists?(args)
      args.first
    else
      find_closest_recipe(recipe_name_list, args.first)
    end
  end

  def self.recipe_name_list
    list = []

    source_root = File.expand_path('../../../recipes', __FILE__)
    Dir.entries(source_root).each do |file_name|
      if file_name.end_with?('.rb')
        recipe_name = file_name.gsub('.rb', '')
        require "potassium/recipes/#{recipe_name}"
        recipe_class = Recipes.const_get(recipe_name.camelize)
        list << recipe_name if recipe_class.method_defined?(:install)
      end
    end

    list
  end

  def self.find_closest_recipe(recipe_list, possible_recipe)
    return nil unless possible_recipe
    highest_distance = 100
    closest_match = nil
    recipe_list.each do |recipe|
      distance = Levenshtein.distance(recipe, possible_recipe)
      if distance < highest_distance
        highest_distance = distance
        closest_match = recipe
      end
    end
    closest_match
  end
end
