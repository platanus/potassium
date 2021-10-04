ENV['RACK_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'spec_helper'

=begin

General
=======

1) Place your unit tests inside the "spec" directory.
2) Run unit tests executing `bin/guard`.
3) Use support directories to add helpers and settings.
   You can only put RSpec configuration on this file.

Support
-------

* spec/support/configurations: put testing related gem settings here.

  For example: spec/support/configurations/shoulda_matchers_config.rb

  ----------------------------------------
  require 'shoulda/matchers'

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
  ----------------------------------------

* spec/support/helpers: place here helpers created by you to use in your unit tests.

  For example: spec/support/helpers/attachments_helpers.rb

  ----------------------------------------------------------------------------------
  module AttachmentsHelpers
    extend ActiveSupport::Concern

    included do
      def create_attachment_file(filename: "pikachu.png", content_type: "image/png")
        Rack::Test::UploadedFile.new(file_fixture(filename), content_type)
      end
    end
  end

  RSpec.configure do |config|
    config.fixture_path = "#{::Rails.root}/spec/assets"
    config.file_fixture_path = "#{::Rails.root}/spec/assets"

    config.include AttachmentsHelpers
  end
  ----------------------------------------------------------------------------------

* spec/support/custom_matchers: place here your custom matchers
  (https://relishapp.com/rspec/rspec-expectations/v/3-10/docs/custom-matchers)

* spec/support/shared_examples: place here your shared examples
  (https://relishapp.com/rspec/rspec-core/v/3-10/docs/example-groups/shared-examples)

System Tests
============

1) Place your system tests inside the "spec/system" directory.
2) Run system tests executing `bin/rspec --tag type:system`.

Support
-------

* spec/support/configurations/system_tests_config.rb: on this file you will find the
  general configuration of the system tests. Keep in mind that this type of test will
  run with the `selenium_chrome_headless` driver unless you put the `no_js` tag.

  For example: spec/system/login_spec.rb

  ----------------------------------------------------------------------------
  require "rails_helper"

  RSpec.describe "Login" do
    let!(:user) { create(:user, email: "lean@platan.us") }

    context "without logged user", :no_js do # will use :rack_test driver
      before { visit("/") }

      it { expect(page).to have_text("Ingresa") }
    end

    context "with logged user" do # will use :selenium_chrome_headless driver
      before { sign_in(user) }

      it { expect(page).to have_text("Hola!") }
    end
  end
  ----------------------------------------------------------------------------

* spec/support/helpers/system: place here helpers created by you
  to use in your system tests.

  For example: spec/support/helpers/login_helpers.rb

  ------------------------------------------------
  module LoginHelpers
    extend ActiveSupport::Concern

    included do
      def sign_in(email, password)
        visit('/users/sign_in')

        within(:xpath, '//*[@id="new_user"]') do
          fill_in('Email', with: email)
          fill_in('Contraseña', with: password)
        end

        click_button('Ingresar')
      end

      def logout
        visit('/users/sign_out')
      end
    end
  end

  RSpec.configure do |config|
    config.include LoginHelpers, type: :system
  end
  ------------------------------------------------

  Remember to include the system helpers with the tag `type: :system`
=end

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_run_when_matching :focus unless Rails.env.production?
end
