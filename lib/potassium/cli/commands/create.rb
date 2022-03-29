require 'potassium/cli_options'

module Potassium::CLI
  extend Potassium::CliOptions

  desc 'Create a new Potassium Rails project.'
  arg 'app_path'
  command :create do |c|
    c.default_desc 'Create a new project.'
    create_options.each { |opts| c.send(opts.delete(:type), opts.delete(:name), opts) }

    c.action do |_global_options, options, _args|
      require 'potassium/newest_version_ensurer'
      require 'potassium/node_version_ensurer'
      require 'potassium/platanus_config'
      require 'potassium/generators/application'
      require 'potassium/template_finder'

      begin
        Potassium::NewestVersionEnsurer.new.ensure! if options['version-check']
        Potassium::NodeVersionEnsurer.new.ensure! if options['node-version-check']
        options = Potassium::PlatanusConfig.new(options).generate! if options['platanus-config']
        template_finder = Potassium::TemplateFinder.new
        template = template_finder.default_template
        template.cli_options = options
        template.source_paths << Rails::Generators::AppGenerator.source_root
        ARGV.push('--skip-javascript', '--skip-bundle')
        template.start
      rescue VersionError => e
        print "\nError: #{e.message}" # rubocop:disable Rails/Output
      end
    end
  end
end
