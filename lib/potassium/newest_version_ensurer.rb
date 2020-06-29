require 'gems'
require 'semantic'
require 'potassium/text_spinner'

class VersionError < StandardError
end

module Potassium
  class NewestVersionEnsurer
    def initialize
      self.installed_version = Semantic::Version.new(Potassium::VERSION)
      self.text_spinner = Potassium::TextSpinner.new
    end

    def ensure!
      spin_text('Checking your Potassium installation') { published_version }

      self.published_version = Semantic::Version.new(Gems.versions('potassium').first['number'])
      raise VersionError.new(update_message) if published_version > installed_version
    end

    private

    attr_accessor :published_version, :installed_version, :text_spinner

    def update_message
      <<~HERE
        Your potassium installation is not up to date.
        The last available version is #{published_version} while the running version is #{installed_version}.
        If you really need to run this outdated version of potassium, re-run this command with the `--no-version-check` flag.
      HERE
    end

    def spin_text(message, &block)
      text_spinner.wait_condition = block
      text_spinner.base_message = message
      text_spinner.start
    end
  end
end
