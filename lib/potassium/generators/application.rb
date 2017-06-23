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
      require_relative "../helpers/template-dsl"
      TemplateDSL.extend_dsl(self, source_path: __FILE__)
      template_location = File.expand_path('../templates/application.rb', File.dirname(__FILE__))
      instance_eval File.read(template_location), template_location
      super

      after_bundle do
        git :init
        git add: "."
        git commit: %{ -m 'Initial commit' -q }
      end
    end
  end
end
