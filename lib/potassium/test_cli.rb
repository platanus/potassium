require "potassium/version"
require 'potassium/cli_options'
require './spec/support/potassium_test_helpers'
require "term/ansicolor"
require "gli"

module Potassium::TestCLI
  extend self
  extend GLI::App
  extend PotassiumTestHelpers
  extend Potassium::CliOptions
  extend Term::ANSIColor

  program_desc "Platanus Rails TEST application generator"
  version Potassium::VERSION
  hide_commands_without_desc true

  desc "Create a new Potassium TEST project"
  command :create do |c|
    c.default_desc "Create a TEST project"

    create_options(true).each { |opts| c.send(opts.delete(:type), opts.delete(:name), opts) }

    c.action do |_global_options, options, _args|
      drop_dummy_database
      remove_project_directory
      create_dummy_project(options)
      puts green("Your test app was created inside the #{project_path} directory")
    end
  end

  exit Potassium::TestCLI.run(ARGV)
end
