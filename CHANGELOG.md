# Changelog

## Unreleased

Fix:
  - Update `ActiveAdmin` to 1.1.0
  - Update `draper` to 3.0.1
  - `FactoryGirl` update to `FactoryBot`

## 5.1.4

Changes:
  - Update ruby to 2.4

Features:
  - Always use https in production

Fix:
  - Schedule recipe selection

## 5.1.3

Features:
  - Rails 5.1.3
  - Use `async` instead of `inline` option as `queue_adapter` on development
  - Adds `s3_region` property to paperclip config.
  - Support HTTPS in paperclip configuration

## 5.1.2

- Rails 5.1.2

## 5.1.1

Features:
  - Rails 5.1.1 (`potassium` version will follow `Rails` version from now on) #136
  - Adds front_end option to include Vue.js and Angular 2 (using `webpacker`)
  - Replaces `bower` by `yarn`
  - Add sidekiq as background processor alternative

Bugfixes:
  - Force `DelayedJobs` migration to use 4.2 `ActiveRecord` class
  - Fix custom `ActiveAdmin` footer
  - Remove heroku dependency from mailer recipe, #124
  - Sentry environment was not being overriden, #123
  - Support for Draper gem

## 3.0.0

Features:
  - Rails 5.0.2
  - `better_errors` and `binding_of_caller` gem in development
  - Update `aws_sdk` to `~> 2.5`
  - Update `paperclip` to `~> 5,0`
  - Add draper gem to decorate models

## 2.3.0

Features:
  - Run bin/setup after DB creation
  - Adds `db:fake_data:load` task for development data. It runs after `db:setup` on development environment
  - Configure Sentry as Error Reporting tool
  - Configure clockwork as scheduler
  - Configure mailer for development environment
  - Configure Rspec to work with Paperclip
  - Update [multi buildpack]([multi-buildpack-heroku]) buildback to the heroku version
  - Update ruby version on CI docker image
  - Adds mailer support with AWS-SES and Sendgrid [#103]
  - Remove adapter property from database config on production. The adapter is delegated to the protocol in the url propertie `postgres://` or `mysql2://`

Bugfixes:
  - Run db tasks with bundle exec

[multi-buildpack-heroku]: http://github.com/ddollar/heroku-buildpack-multi

## 2.2.0

- Adds tzinfo-data gem [#101]

## 2.1.0

- Fix discard_gem helper
- Adds install command for database recipe
- Remove check for heroku pipelines plugins, [#88]
- Use postgresql by default, [#83]
- Update ruby to `2.3.1` [#89]

## 2.0.0

Features:
  - Use `.env` instead of `.rbenv-vars`
  - Use Puma instead of unicorn
  - Gets ruby version from http://ruby.platan.us/latest
  - Adds the install command
  - Adds heroku buildpack support using the [multi buildpack](multi-buildpack)
  - Adds `rack-timeout` to prevent long running requests
  - Adds [deploy-tasks buildpack](deploy-tasks) mainly to perform migrations, [#39]
  - Add Delayed Jobs to handle background processes, [#41]
  - Adds continuous integration using [CircleCI](https://circleci.com)
  and docker, [#51]
  - Adds heroku app creation to the heroku recipe, [#60]
  - Adds github repo creation through hub
  - Build a project Readme based on the potassium installed recipes, [#61]

[multi-buildpack]: http://github.com/ddollar/heroku-buildpack-multi
[deploy-tasts]: http://github.com/gunpowderlabs/buildpack-ruby-rake-deploy-tasks
[#39]: http://github.com/platanus/potassium/pull/39
[#41]: http://github.com/platanus/potassium/pull/41
[#51]: http://github.com/platanus/potassium/pull/51

## 1.3

Features:
  - Added update checking before the create command. It will (almost) force that potassium should be updated.

Chore:
  - Returned to use SemVer because in 1.2.3 and 1.2.4 there were features and they should have been 1.3 and 1.4. This version will be 1.3 to not lose some versions in the void but new features means a second number jump and we will have to ensure that.

## 1.2.4

Features:
  - Added Rack CORS gem and config.

## 1.2.3

Bugfixes:
  - Fix database name to use when dashes are present.

Features:
  - Added optional API support that includes the following:
    - A concern that offer standard responses to common errors.
    - Versionist Support.
    - `simple_token_authentication`, `active_model_serializers` and `responders` gem.
    - A default responder for API common behavior.

## 1.2.2

Bugfixes:
  - Multiple changes to make it work correctly within rubygems.

## 1.2.1

Refactor:
  - Speed up `help` and `version` commands by lazily requiring rails dependencies.

## 1.2.0

Bugfixes:
  - Fixed RSpec load with Zeus (by using rails_helper instead on spec_helper in .rspec).
  - Removed RSpec `--warnings` option.

Features:
  - Added `aws-sdk` gem (< 2).
  - Added `activeadmin_addons` when using ActiveAdmin.
  - Added AngularJS support for ActiveAdmin.

Chore:
  - Removed several questions for ActiveAdmin support.

## 1.1.0

Bugfixes:
  - Fixed dependencies management.

Features:
  - Added a question for choosing application language and integration with devise-i18n.

## 1.0.1

Bugfixes:
  - Removed `default_command` call to fix --version usage.
