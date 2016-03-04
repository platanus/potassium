require "rails/generators"
require "rails/generators/rails/app/app_generator"
require "inquirer"
require "potassium/recipe"

module Potassium
  class ApplicationGenerator < Rails::Generators::AppGenerator
    class << self
      attr_accessor :cli_options
    end

    def finish_template
      require_relative "./helpers/template-dsl"
      TemplateDSL.extend_dsl(self, source_path: __FILE__)
      template_location = File.expand_path('./template.rb', File.dirname(__FILE__))
      instance_eval File.read(template_location), template_location
      super
    end
  end
end
