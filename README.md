# Potassium

A Rails application generator from [Platanus](https://github.com/platanus), inspired by [Suspenders](https://github.com/thoughtbot/suspenders).

## Installation

Run the following command:

    $ gem install potassium

## Usage

To create a new project:

    $ potassium create project-name

## What's inside Potassium?

Potassium Rails apps includes integrations with the following technologies we use by convention:

- Rbenv for managing our ruby versions.
- Rbenv-vars for keeping secrets and by-server configurations.
- Bower for frontend assets packages.
- EditorConfig for keeping all our editor configurations the same. 
- Pry and Pry-ByeBug for a less painful debugging experience.
- RSpec for unit and integration testing.
- FactoryGirl for keep factories for the tests.
- Guard for continuous testing and other watch-related tasks.

And some optional integrations that will be asked for on project's creation:

- PostgreSQL or MySQL for our databases.
- Devise for authentication.
- ActiveAdmin for admin interfaces.
- Pundit for role-based authorization.

## How do i add something new to Potassium?

In the [lib/potassium/templates/application](lib/potassium/templates/application) folder, you will find [the template](lib/potassium/templates/application/template.rb). You should follow the next conventions to add something:

*__NOTE:__ If you only want to use Potassium but not to add something new, the next parts shouldn't be necessary.*

### Asking

If you need to ask something to the user, follow the next steps:

1. Create a ruby file on the [recipes/asks](lib/potassium/templates/application/recipes/asks) folder.
2. Then, ask something using the methods defined in [Inquirer](https://github.com/arlimus/inquirer.rb), that we use by default. Use the [DSL](docs/dsl.md) to store some information.
3. Finally, register the **ask** you created in [the template](lib/potassium/templates/application/template.rb):

  ```ruby
  run_action(:asking) do
    # ...
    eval_file "recipes/asks/my_ask.rb"
  end
  ```

### Installing Something

Now, to add some behavior, thanks the [DSL](docs/dsl.md), we have a kind of flow of what is happening in the template execution. To understand this better, please read [the template](lib/potassium/templates/application/template.rb). Anyway, the structure is like this:

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

5. Ready, this should be enough.

### The DSL

To see some further documentation of what we added to the rails template's DSL, check the [DSL documentation](docs/dsl.md). Remember that the DSL we are documenting is an extension over the [Rails Application Template DSL](http://edgeguides.rubyonrails.org/rails_application_templates.html), that itself is a dsl based on [Thor](https://github.com/erikhuda/thor/wiki).
