# Changelog

## Unreleased

Features:
  - Check node version before project creation [#305](https://github.com/platanus/potassium/pull/305)
  - Disable observers in test environment [#319](https://github.com/platanus/potassium/pull/319)
  - Allow user to select custom Github repository [#318](https://github.com/platanus/potassium/pull/318)
  - Add pull request template to github enabled projects [#320](https://github.com/platanus/potassium/pull/320)
  - Use a Ruby gem instead of hub to create Github repositories [#323](https://github.com/platanus/potassium/pull/323)
  - Add dockerized redis configuration when using background processor [#329](https://github.com/platanus/potassium/pull/329)

Fix:
  - Fix shrine issues related to configuration and uploader validation [#302](https://github.com/platanus/potassium/pull/302)
  - Fix database recipe not running recommended generator for strong_migrations gem [#310](https://github.com/platanus/potassium/pull/310)
  - Fix puma config that was causing it to crash on server start while on development [#313](https://github.com/platanus/potassium/pull/313)
  - Fix purge css being enabled in development [#327](https://github.com/platanus/potassium/pull/327)

## 6.0.0

Features:
  - Update ActiveAdmin to 2.6 [#246](https://github.com/platanus/potassium/pull/246)
  - Update bundler to 2.0 [#250](https://github.com/platanus/potassium/pull/250)
  - Update Rails to 6.0.2 [#251](https://github.com/platanus/potassium/pull/251)
  - Improve specs performance [#259](https://github.com/platanus/potassium/pull/259)
  - Dasherize app name in docker compose related files [#261](https://github.com/platanus/potassium/pull/261)
  - Split specs by timings in CircleCI [#263](https://github.com/platanus/potassium/pull/263)
  - Update ruby to 2.7.0 [#264](https://github.com/platanus/potassium/pull/264)
  - Add tailwindcss [#266](https://github.com/platanus/potassium/pull/266)
  - Update rack-cors to 1.1 [#269](https://github.com/platanus/potassium/pull/269)
  - Use safer CORS configuration exposing only API and public resources [#271](https://github.com/platanus/potassium/pull/271)
  - Add option to support Vue in ActiveAdmin [#272](https://github.com/platanus/potassium/pull/272)
  - Add tests for Vue [#273](https://github.com/platanus/potassium/pull/278)
  - Remove simple commands and docker-compose args in Makefile [#279](https://github.com/platanus/potassium/pull/279)
  - Remove Paperclip and add [Shrine](https://github.com/shrinerb/shrine) for file_storage recipe [#291](https://github.com/platanus/potassium/pull/291)
  - Add linting job to CircleCI builds using [reviewdog](https://github.com/reviewdog/reviewdog) and per-project dependencies/configurations for linters [#292](https://github.com/platanus/potassium/pull/292)
  - Remove angular_admin recipe [#297](https://github.com/platanus/potassium/pull/297)

Fix:
  - Correctly use cache for bundle dependencies in CircleCI build [#244](https://github.com/platanus/potassium/pull/244) and [#258](https://github.com/platanus/potassium/pull/258)
  - Fix model auto annotate [#260](https://github.com/platanus/potassium/pull/260)
  - Fix sidekiq repeated installation on potassium create if selecting mailer [#262](https://github.com/platanus/potassium/pull/262)
  - Include ApiErrorConcern in all environments [#270](https://github.com/platanus/potassium/pull/270)

## 5.2.3

Features:
  - Add restore-from commands for pg_restore in makefile [#237](https://github.com/platanus/potassium/pull/237)
  - Allow usage of vue components in rails views out of the box [#231](https://github.com/platanus/potassium/pull/231)
  - Add data migrate [#227](https://github.com/platanus/potassium/pull/227)
  - Add raven capture in error handler if sentry enabled [#226](https://github.com/platanus/potassium/pull/226)
  - Remove unnecesary aws-sdk gems in favor of specific ones [#221](https://github.com/platanus/potassium/pull/221)
  - Unify storage options and deprecate paperclip [#211](https://github.com/platanus/potassium/pull/211)

Fix:
  - Fix gather_gem issue when multiple versions passed as argument [#242](https://github.com/platanus/potassium/pull/242)
  - Support "None" passed as CLI flag option in file storage [#240](https://github.com/platanus/potassium/pull/240)
  - Add sidekiq worker to Procfile if installed after project setup (with heroku) [#234](https://github.com/platanus/potassium/pull/234)
  - Include test_data volume to CI compose for bundler related data [#229](https://github.com/platanus/potassium/pull/229)
  - Comment out schedule entry in sidekiq.yml [#225](https://github.com/platanus/potassium/pull/225)
  - Use ruby image for potassium test build [#224](https://github.com/platanus/potassium/pull/224)
  - Use webpacker from rubygems instead of repo master [#222](https://github.com/platanus/potassium/pull/222)
  - Add rubocop-rspec for compatibility with updated linters in spec [#218](https://github.com/platanus/potassium/pull/218)
  - Remove containers after spec run [#216](https://github.com/platanus/potassium/pull/216)
  - Fix database container install [#214](https://github.com/platanus/potassium/pull/214)

## 5.2.2

Features:
  - Implement release phase on heroku
  - Add sendgrid_dev support

Fix:
  - Fix Circle CI
  - Fix services containers env variables

## 5.2.1

Features:
  - Databases are now provided as docker containers

Changes:
  - Update postgres to 11
  - Update mysql to 5.7
  - Update rubocop to `~> 0.65.0`
  - Puma worker timeout is extended to 1 day in development env
  - Spring is loaded only in development env
  - Remove version requirement for `pg`

Fix:
  - Update mysql2 to `~> 0.5.0` (required for rails 5+)
  - Use `RACK_TIMEOUT` env var instead deprecated setter

## 5.2.0

Features:
  - Add Active Storage recipe

Changes:
  - Update AWS to 3
  - Update Rails to 5.2.1
  - Update `ActiveAdmin` to 1.3.0
  - Update ruby to 2.5
  - Update to circleci 2

Fix:
  - Update `draper` to 3.0.1
  - `FactoryGirl` update to `FactoryBot`
  - `pg` gem has now explicit version: `~> 0.21`

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
