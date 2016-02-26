module Potassium::CLI
  desc "Create a new Potassium Rails project."
  arg 'app_path'
  command :create do |c|
    c.default_desc "Create a new project."
    c.switch "version-check",
      default_value: true,
      desc: "Performs a version check before running.",
      negatable: true

    c.flag [:db, :database],
      desc: "Decides which database to use. Available: mysql, postgresql, none"
    c.flag [:lang, :language],
      desc: "Decides which language to use. Available: es, en"
    c.switch "devise",
      desc: "Whether to use Devise for authentication or not",
      negatable: true
    c.switch "devise-user-model",
      desc: "Whether to create a User model for Devise",
      negatable: true
    c.switch "admin",
      desc: "Whether to use ActiveAdmin or not",
      negatable: true
    c.switch "angular-admin",
      desc: "Whether to use Angular within ActiveAdmin or not",
      negatable: true
    c.switch "pundit",
      desc: "Whether to use Pundit for authorization or not",
      negatable: true
    c.switch "api",
      desc: "Whether to apply the API mode or not",
      negatable: true
    c.switch "paperclip",
      desc: "Whether to include Paperclip as dependency",
      negatable: true
    c.switch "heroku",
      desc: "Whether to prepare to application for Heroku or not",
      negatable: true

    c.action do |_global_options, options, _args|
      require "potassium/newest_version_ensurer"

      begin_creation = -> do
        require "potassium/templates/application/generator"
        require "potassium/template_finder"

        template_finder = Potassium::TemplateFinder.new
        template = template_finder.default_template
        template.cli_options = options
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
