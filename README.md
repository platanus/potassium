# Potassium [![Circle CI](https://circleci.com/gh/platanus/potassium.svg?style=svg)](https://circleci.com/gh/platanus/potassium)

A Rails application generator from [Platanus](https://github.com/platanus), inspired by [Suspenders](https://github.com/thoughtbot/suspenders).

## Installation

You have to install Potassium globally:

    $ gem install potassium

## Usage

### Starting a new project from scratch

Use the `potassium create` command to create a new project:

    $ potassium create project-name

> It's important to note that it will perform a version check before running to ensure that you're using the latest potassium. Also, if you feel that it's too slow, you may need to update rubygems: `gem update --system`.

### Adding recipes to an existing project

Use the `potassium install` command to add a recipe to a project:

    $ potassium install i18n

You can run the command on its own to view all the available recipes and select one:

    $ potassium install

## What's inside Potassium?

Potassium Rails apps includes the following gems and technologies:

- [Ruby](https://www.ruby-lang.org) Set the project ruby version based on http://ruby.platan.us/latest
- [dotenv](https://github.com/bkeepers/dotenv) load environmental variables in development
- [Bower](http://bower.io) for frontend assets packages.
- [EditorConfig](http://editorconfig.org) for keeping all our editor configurations the same.
- [pry](http://pryrepl.org) and [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug) for a less painful debugging experience.
- [RSpec](http://rspec.info) for unit and integration testing.
- [FactoryGirl](https://github.com/thoughtbot/factory_girl) for test factories.
- [Guard](http://guardgem.org) for continuous testing and other watch-related tasks.
- [AWS-SDK](https://github.com/aws/aws-sdk-ruby) for file uploads, sdks, etc and because we use AWS.
- [Puma](https://github.com/puma/puma) to serve HTTP requests
- [Rack Timeout](https://github.com/heroku/rack-timeout) to abort requests that are
  taking too long

The following optional integrations are added too:

- [PostgreSQL](http://www.postgresql.org) or [MySQL](https://www.mysql.com) for the database.
- [Devise](https://github.com/plataformatec/devise) for authentication.
- [ActiveAdmin](http://activeadmin.info) for admin interfaces.
- [ActiveAdminAddons](https://github.com/platanus/activeadmin_addons) for some help with ActiveAdmin.
- [Pundit](https://github.com/elabs/pundit) for role-based authorization.
- [DelayedJob](https://github.com/collectiveidea/delayed_job) to execute longer tasks in the background.

A few more things are added to the project:

- A [low database connection pool limit][pool]

[pool]: https://devcenter.heroku.com/articles/concurrency-and-database-connections

### API support

The optional API support includes:

- [Responders](https://github.com/plataformatec/responders) for dry-ing our api controllers.
- [Versionist](https://github.com/bploetz/versionist) for some flexible api versioning.
- [ActiveModel::Serializers](https://github.com/rails-api/active_model_serializers) for record serialization.
- [Simple Token Authentication](https://github.com/gonzalo-bulnes/simple_token_authentication) for stateless API authentication.

### Heroku support

When you choose to deploy to heroku a few extra things are added for the project.

- Adds the [Rails Stdout Logging][logging-gem] gem
  to configure the app to log to standard out,
  which is how [Heroku's logging][heroku-logging] works.
- Adds a [Procfile][procfile] to define the processes to run in heroku
- Adds a `.buildpacks` file with the default buildpacks to use. It use the
  following buildpacks:

  | index | buildpack | description |
  |-------|-----------|-------------|
  | 1.    | [bower][heroku-buildpack-bower] | to make sure `bower install` run before the assets precompilation task |
  | 2.    | [ruby-version][heroku-buildpack-ruby-version] | to support the use of `.ruby-version` file to instruct heroku which ruby version to use |
  | 3.    | [ruby][heroku-buildpack-ruby] | the base buildpack to run ruby applications |
  | 4.    | [ruby-deploy-tasks][buildpack-deploy-tasks] | to run rake task after the deployment is complete, for example `db:migrate` |

  **Note**: You need to set your app buildpack with the [multi-buildpack][heroku-buildpack-multi]

[logging-gem]: https://github.com/heroku/rails_stdout_logging
[heroku-logging]: https://devcenter.heroku.com/articles/logging#writing-to-your-log
[procfile]: https://devcenter.heroku.com/articles/procfile
[heroku-buildpack-ruby-version]: http://github.com/platanus/heroku-buildpack-ruby-version
[heroku-buildpack-bower]: http://github.com/platanus/heroku-buildpack-bower
[heroku-buildpack-ruby]: http://github.com/heroku/heroku-buildpack-ruby
[heroku-buildpack-multi]: http://github.com/ddollar/heroku-buildpack-multi
[buildpack-deploy-tasks]: http://github.com/gunpowderlabs/buildpack-ruby-rake-deploy-tasks

## Contributing

### How do I add something new to Potassium?

In the [lib/potassium/templates/application](lib/potassium/templates/application) folder, you will find [the template](lib/potassium/templates/application/template.rb). You should follow the next conventions to add something:

*__NOTE:__ If you only want to use Potassium but not to add something new, the next parts can be easily skipped.*

#### Ask

If you need to ask something to the user before doing something, follow the next steps:

1. Create a ruby file on the [recipes/asks](lib/potassium/templates/application/recipes/asks) folder.
2. Then, ask something using the methods defined in [Inquirer](https://github.com/arlimus/inquirer.rb), that we use by default. Use the [DSL](docs/dsl.md) to store some information.
3. Finally, register the **ask** you created in [the template](lib/potassium/templates/application/template.rb):

  ```ruby
  run_action(:asking) do
    # ...
    eval_file "recipes/asks/my_ask.rb"
  end
  ```

#### Install

Now, to add some behavior, thanks to the [DSL](docs/dsl.md) we have a kind of standard flow of what happens when a new project is created. To understand this better, please read [the template](lib/potassium/templates/application/template.rb). The structure looks like this:

1. Clean the Gemfile and add the base gems that rails needs to work.
2. Run all the **asks** recipes.
3. Execute all the **recipes**, that are ruby files stored on the [recipes](lib/potassium/templates/application/recipes) folder. They specify what gems are needed and registers callbacks based on this process, usually to execute things after the gem installation happened or after some other recipe finished his work.
4. Install the gems, filling the Gemfile before with all the gathered gems.
5. Finally, create the database.

The main step is the 3rd, when we run the recipes. A recipe can do anything (because is a ruby script) but their responsability should be to gather gems and register callbacks for the process.

For example, if we want to create an optional recipe to add a gem called `banana_split` that needs to run a generator, we can do the following.

1. Create the **ask** file:

  ```ruby
  # application/recipes/ask/banana_split.rb
  use_banana_split = Ask.confirm("Do you want to use Banana Split?")
  set(:use_banana_split, true) if use_banana_split
  ```

2. Then, register the **ask**:

  ```ruby
  run_action(:asking) do
    # ...
    eval_file "recipes/asks/banana_split.rb"
  end
  ```

3. Create the **recipe**. Register a gem using `gather_gem` and create a callback to be called after the `gem_install` action succeded to run the generator. `gem_install` is one of the main actions that should be easily visible with a sneak peek in [the template](lib/potassium/templates/application/template.rb).

  ```ruby
  # application/recipes/banana_split.rb
  if get(:use_banana_split)
    gather_gem('banana_split', '~> 1.2')

    after(:gem_install) do
      generate('banana_split:install')
    end
  end
  ```

4. Register the **recipe**:

  ```ruby
  run_action(:recipe_loading) do
    # ...
    eval_file "recipes/banana_split.rb"
  end
  ```

5. Ready, let's start working on your new project.

#### The DSL

To see further documentation of what we added to the rails template's DSL, check the [DSL documentation](docs/dsl.md). Remember that the DSL we are documenting is an extension over the [Rails Application Template DSL](http://edgeguides.rubyonrails.org/rails_application_templates.html), that itself is a dsl based on [Thor](https://github.com/erikhuda/thor/wiki).

## Credits

Thank you [contributors](https://github.com/platanus/potassium/graphs/contributors)!

<img src="http://platan.us/gravatar_with_text.png" alt="Platanus" width="250"/>

potassium is maintained by [platanus](http://platan.us).

## License

Potassium is © 2014 platanus, spa. It is free software and may be redistributed under the terms specified in the LICENSE file.
