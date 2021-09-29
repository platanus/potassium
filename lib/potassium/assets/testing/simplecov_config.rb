require 'simplecov'
require 'simplecov_text_formatter'
require 'simplecov_linter_formatter'

SimpleCovLinterFormatter.scope = ENV.fetch(
  "SIMPLE_COV_LINTER_SCOPE", "own_changes"
).to_sym
SimpleCovLinterFormatter.json_filename = ENV.fetch(
  "SIMPLE_COV_LINTER_JSON_FILENAME", ".resultset.json"
)

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
