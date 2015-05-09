# Potassium

A Rails application generator from [Platanus](https://github.com/platanus), inspired by [Suspenders](https://github.com/thoughtbot/suspenders).

## Installation

Just install it globally:

    $ gem install potassium

## Usage

Use the `potassium` command to create a new project:

    $ potassium create project-name

## What's inside Potassium?

Potassium Rails apps includes the following gems and technologies:

- [rbenv](https://github.com/sstephenson/rbenv) for managing the project's ruby version.
- [rbenv-vars](https://github.com/sstephenson/rbenv-vars) for keeping secrets and by-server configurations.
- [Bower](http://bower.io) for frontend assets packages.
- [EditorConfig](http://editorconfig.org) for keeping all our editor configurations the same. 
- [pry](http://pryrepl.org) and [pry-byebug](https://github.com/deivid-rodriguez/pry-byebug) for a less painful debugging experience.
- [RSpec](http://rspec.info) for unit and integration testing.
- [FactoryGirl](https://github.com/thoughtbot/factory_girl) for test factories.
- [Guard](http://guardgem.org) for continuous testing and other watch-related tasks.

And some optional integrations that will be asked for on project's creation:

- [PostgreSQL](http://www.postgresql.org) or [MySQL](https://www.mysql.com) for the database.
- [Devise](https://github.com/plataformatec/devise) for authentication.
- [ActiveAdmin](http://activeadmin.info) for admin interfaces.
- [Pundit](https://github.com/elabs/pundit) for role-based authorization.

## Contributing

### How do i add something new to Potassium?

In the [lib/potassium/templates/application](lib/potassium/templates/application) folder, you will find [the template](lib/potassium/templates/application/template.rb). You should follow the next conventions to add something:

*__NOTE:__ If you only want to use Potassium but not to add something new, the next parts shouldn't be necessary.*

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

Now, to add some behavior, thanks to the [DSL](docs/dsl.md) we have a kind of standard flow of what happens when a new project is created. To understand this better, please read [the template](lib/potassium/templates/application/template.rb). Anyway, the structure is like this:

1. Clean the Gemfile and add the base gems that rails needs to work.
2. Then, run all the **asks** recipes.
3. Then, execute all the **recipes**, that are ruby files stored on the [recipes](lib/potassium/templates/application/recipes) folder. They specify what gems are needed and registers callbacks based on this process, usually to execute things after the gem installation happened or after some other recipe finished his work.
4. Then, install the gems, filling the Gemfile before with all the gathered gems.
5. Finally, create the database.

The main step is the 3, when we run the recipes. A recipe can do anything (because is a ruby script) but what should be their main responsabilities are to gather gems and register callbacks for the process.

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

3. Create the **recipe**. Register a gem using `gather_gem` and use a callback to run after the `gem_install` action succeded to run the generator. `gem_install` is one of the main actions that should be easily visible with a sneak peek in [the template](lib/potassium/templates/application/template.rb).

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

To see some further documentation of what we added to the rails template's DSL, check the [DSL documentation](docs/dsl.md). Remember that the DSL we are documenting is an extension over the [Rails Application Template DSL](http://edgeguides.rubyonrails.org/rails_application_templates.html), that itself is a dsl based on [Thor](https://github.com/erikhuda/thor/wiki).
