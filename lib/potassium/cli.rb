require "potassium/version"
require "gli"

# rubocop:disable Rails/Exit
module Potassium::CLI
  extend GLI::App

  program_desc "Platanus Rails application generator"
  version Potassium::VERSION
  hide_commands_without_desc true
  commands_from "potassium/cli/commands"

  exit Potassium::CLI.run(ARGV)
end
# rubocop:enable Rails/Exit
