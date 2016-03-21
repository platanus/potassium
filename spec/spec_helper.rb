require "bundler/setup"

Bundler.require(:default, :test)

require (Pathname.new(__FILE__).dirname + "../lib/potassium").expand_path

Dir["./spec/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.include PotassiumTestHelpers

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!

  config.before(:all) do
    add_fakes_to_path
    create_tmp_directory
  end

  config.before(:each) do
    FakeGithub.clear!
  end
end
