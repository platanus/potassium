module Potassium::CLI
  command :create do |c|
    c.action do |global_options, options, args|
      require "potassium/templates/application/generator"
      require "potassium/template_finder"

      template_finder = Potassium::TemplateFinder.new
      template = template_finder.default_template
      template.source_paths << Rails::Generators::AppGenerator.source_root
      template.start
    end
  end
end
