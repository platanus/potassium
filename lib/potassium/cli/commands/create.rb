require 'potassium/cli_options'

module Potassium::CLI
  extend Potassium::CliOptions

  desc "Create a new Potassium Rails project."
  arg 'app_path'
  command :create do |c|
    c.default_desc "Create a new project."
    c.switch "version-check",
      default_value: true,
      desc: "Performs a version check before running.",
      negatable: true

    create_options.each { |opts| c.send(opts.delete(:type), opts.delete(:name), opts) }

    c.action do |_global_options, options, _args|
      require "potassium/newest_version_ensurer"

      begin_creation = -> do
        require "potassium/generators/application"
        require "potassium/template_finder"

        template_finder = Potassium::TemplateFinder.new
        template = template_finder.default_template
        template.cli_options = options
        template.source_paths << Rails::Generators::AppGenerator.source_root
        ARGV.push('--skip-webpack-install', '--skip-bundle')
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
