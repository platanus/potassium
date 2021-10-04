require 'simplecov'
require 'simplecov_text_formatter'
require 'simplecov_linter_formatter'

SimpleCovLinterFormatter.setup do |config|
  config.scope = ENV.fetch(
    "SIMPLE_COV_LINTER_SCOPE", :own_changes
  )
  config.json_filename = ENV.fetch(
    "SIMPLE_COV_LINTER_JSON_FILENAME", ".resultset.json"
  )
  config.summary_enabled = ENV.fetch(
    "SIMPLE_COV_LINTER_SUMMARY_ENABLED", true
  )
  config.summary_enabled_bg = ENV.fetch(
    "SIMPLE_COV_LINTER_SUMMARY_BG_ENABLED", true
  )
  config.summary_covered_bg_color = ENV.fetch(
    "SIMPLE_COV_LINTER_SUMMARY_COVERED_BG_COLOR", :darkgreen
  )
  config.summary_not_covered_bg_color = ENV.fetch(
    "SIMPLE_COV_LINTER_SUMMARY_NOT_COVERED_BG_COLOR", :firebrick
  )
  config.summary_text_color = ENV.fetch(
    "SIMPLE_COV_LINTER_SUMMARY_TEXT_COLOR", :white
  )
  config.summary_files_sorting = ENV.fetch(
    "SIMPLE_COV_LINTER_SUMMARY_FILES_SORTING", :coverage
  )
end

SimpleCov.start 'rails' do
  add_group 'Commands', 'app/commands'
  add_group 'Services', 'app/services'
  add_group 'Observers', 'app/observers'
  add_group 'Policies', 'app/policies'
  add_group 'Utils', 'app/utils'
  add_group 'Extensions', 'app/extensions'

  add_filter %r{app/controllers/([a-z]|_)*_controller.rb}
  add_filter 'app/admin'
  add_filter 'app/channels'
  add_filter 'app/uploaders'
  add_filter 'app/serializers'
  add_filter 'app/clients'
  add_filter 'app/helpers'
  add_filter 'app/decorators'
  add_filter 'app/responders'
  add_filter 'lib/fake_data_loader.rb'
  add_filter 'lib/vue_component.rb'

  if ENV["CIRCLECI"]
    formatter(SimpleCov::Formatter::TextFormatter)
  else
    formatter(
      SimpleCov::Formatter::MultiFormatter.new(
        [
          SimpleCov::Formatter::LinterFormatter,
          SimpleCov::Formatter::HTMLFormatter
        ]
      )
    )
  end
end
