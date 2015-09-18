require "rails/generators"
require "rails/generators/rails/app/app_generator"
require "inquirer"

module Potassium
  class RecipeGenerator < Rails::Generators::NamedBase
    def run_generator
      require_relative "./helpers/template-dsl"
      TemplateDSL.extend_dsl(self, source_path: __FILE__)
      template_location = File.expand_path('./recipe_template.rb', File.dirname(__FILE__))
      instance_eval File.read(template_location), template_location
    end
  end
end
