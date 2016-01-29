module Potassium::CLI
  desc "Create a new Potassium Rails project."
  arg 'app_path'
  command :create do |c|
    c.default_desc "Create a new project."
    c.switch "version-check", default_value: true,
                              desc: "Performs a version check before running.",
                              negatable: true

    c.action do |_global_options, options, _args|
      require "potassium/newest_version_ensurer"

      begin_creation = -> do
        require "potassium/templates/application/generator"
        require "potassium/template_finder"

        template_finder = Potassium::TemplateFinder.new
        template = template_finder.default_template
        template.source_paths << Rails::Generators::AppGenerator.source_root
        template.start
      end

      if options["version-check"]
        ensurer = Potassium::NewestVersionEnsurer.new
        ensurer.ensure(&begin_creation)
      else
        begin_creation.call
      end
    end
  end
end
