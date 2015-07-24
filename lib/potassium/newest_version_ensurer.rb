require "term/ansicolor"
require "gems"
require "semantic"
require "potassium/text_spinner"

module Potassium
  class NewestVersionEnsurer
    include Term::ANSIColor

    def initialize(current_version = Potassium::VERSION)
      self.current_version = Semantic::Version.new(current_version)
      self.text_spinner = Potassium::TextSpinner.new
    end

    def ensure(&success_block)
      spin_text("Checking your Potassium installation") { latest_version }

      self.latest_version = Semantic::Version.new(
        Gems.versions("potassium").first["number"]
      )

      if latest_version <= current_version
        up_to_date
        success_block.call
      else
        please_update
      end
    end

    private

    attr_accessor :latest_version, :current_version, :text_spinner

    def up_to_date
      puts green("\nYour Potassium installation is up to date.")
    end

    def please_update
      puts red("\nYour Potassium installation is not up to date.")
      puts red("Found: #{current_version}")
      puts red("Expected: #{latest_version}\n")
      print white("Please run: ")
      print green("gem update potassium ")
      print white("to upgrade your potassium installation.\n\n")
      print white("If you want to run this outdated version of potassium anyway, ")
      print white("re-run this command with the ")
      print green("--no-version-check")
      puts white(" flag.")
    end

    def spin_text(message, &block)
      text_spinner.wait_condition = block
      text_spinner.base_message = message
      text_spinner.start
    end
  end
end
