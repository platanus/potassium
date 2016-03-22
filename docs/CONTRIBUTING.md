# Contributing

## How do I add something new to Potassium?

### Template

In the [lib/potassium/templates](/lib/potassium/templates) folder, you will find [the template][the-template].

Now, to add some behavior, thanks to the [DSL](/docs/DSL.md) we have a kind of standard flow of what happens when a new project is created. To understand this better, please read [the template][the-template]. The structure looks like this:

1. Clean the `Gemfile` and add the base gems that rails needs to work.
2. Run all the `ask` methods from the recipes.
3. Execute all the `create` methods from the recipes, that are ruby classes stored on the [recipes](/lib/potassium/recipes) folder. Here you can specify what gems are needed and register callbacks based on this process, usually to execute things after the gem installation happened or after some other recipe finished his work.
4. Install the gems, filling the `Gemfile` before with all the gathered gems.
5. Finally, create the database.

The main step is the 3rd, when we call the `create` methods from the recipes. A recipe can do anything (because is a ruby script) but their responsability should be to gather gems and register callbacks for the process.

### Recipe

The recipes are classes defined in the `Recipes` module that inherit from
`Rails::AppBuilder` and by convention can implement some of the following
methods `ask`, `create` and `install`. So they took this form.

```ruby
class Recipes::MyRecipe < Rails::AppBuilder
  def ask
    #...
  end

  def create
    #...
  end

  def install
    #...
  end
end
```

The recipes should be created in the `lib/potassium/recipes` folder.

#### Methods

For example, if we want to create an optional recipe to add a gem called
`banana_split` that needs to run a generator, we can do the following.

##### | `ask`

This method is used if you need to ask something to the user before doing something.

1. Use the [answer method](DSL.md#answer-helpers) to ask something using the methods defined in [Inquirer](https://github.com/arlimus/inquirer.rb), that we use by default. Use the [DSL](/docs/dsl.md) to store some information.

    ```ruby
    def ask
      use_banana_split = Ask.confirm("Do you want to use Banana Split?")
      set(:use_banana_split, true) if use_banana_split
    end
    ```

2. Then, register the question you created in [the template][the-template]:

    ```ruby
    run_action(:asking) do
      # ...
      ask :myRecipe
    end
    ```

##### | `create`

We'll call this method to add specific functionality to the rails project.

1. In the `create` method register a gem using `gather_gem` and create a callback to be called after the `gem_install` action succeded to run the generator. `gem_install` is one of the main actions that should be easily visible with a sneak peek in [the template][the-template].

    ```ruby
    def create
      if get(:use_banana_split)
        gather_gem('banana_split', '~> 1.2')

        after(:gem_install) do
          generate('banana_split:install')
        end
      end
    end
    ```

2. Then, register the recipe creation in [the template][the-template]:

    ```ruby
    run_action(:recipe_loading) do
      # ...
      create :banana_split
    end
    ```

##### | `install`

The install method will be called when you use the `install` command from potassium.
For example if you run `portassium install devise` this will use
[the recipe template](/lib/potassium/templates/recipe.rb) to load an execute the
`install` method for the **devise** recipe.

You can defined the main functionallity of a recipe in a private method and call
it from the `create` and `install` methods.

```ruby
def install
  if gem_exists?(/banana_split/)
    info "Banana Split is already installed"
  else
    install_banana
  end
end

private

def install_banana
  #...
end
```


## The DSL

To see further documentation of what we added to the rails template's DSL, check the [DSL documentation](/docs/DSL.md).

> Remember that the DSL we are documenting is an extension over the [Rails Application Template DSL](http://edgeguides.rubyonrails.org/rails_application_templates.html), that itself is a dsl based on [Thor](https://github.com/erikhuda/thor/wiki).

[the-template]: /lib/potassium/templates/application.rb
