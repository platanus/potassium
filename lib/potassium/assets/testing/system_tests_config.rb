RSpec.configure do |config|
  config.before(:each, type: :system) do |example|
    driver = example.metadata[:no_js] ? :rack_test : :selenium_chrome_headless
    driven_by(driver)
  end
end
