## 1.0.1

Bugfixes:
  - Removed `default_command` call to fix --version usage.

## 1.1.0

Bugfixes:
  - Fixed dependencies management.

Features:
  - Added a question for choosing application language and integration with devise-i18n.

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

## 1.2.1

Refactor:
  - Speed up `help` and `version` commands by lazily requiring rails dependencies.

## 1.2.2

Bugfixes:
  - Multiple changes to make it work correctly within rubygems.

## 1.2.3

Bugfixes:
  - Fix database name to use when dashes are present.

Features:
  - Added optional API support that includes the following:
    - A concern that offer standard responses to common errors.
    - Versionist Support.
    - `simple_token_authentication`, `active_model_serializers` and `responders` gem.
    - A default responder for API common behavior.
