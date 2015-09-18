require 'levenshtein'
require 'inquirer'
require "potassium/templates/application/recipe_generator"

module Potassium::CLI
  desc "Installs a new feature or library"
  command :install do |c|
    c.action do |global_options, options, args|
      if args.first.nil?
        index = Ask.list('Select a recipe to install', recipe_name_list)
        ARGV << recipe_name_list[index]
        Potassium::RecipeGenerator.start
      else
        if recipe_exists?(args)
          Potassium::RecipeGenerator.start
        else
          puts "Oops! Sorry, that recipe doesn't exist. Were you looking for this?: #{guess_recipe_name(args)}"
        end
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
    @recipe_name_list ||= begin
      source_root = File.expand_path('../../../templates/application/recipes', __FILE__)
      files = Dir.entries(source_root).select { |e| e.end_with?('.rb') }
      files.map { |e| e.gsub('.rb', '') }
    end
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
