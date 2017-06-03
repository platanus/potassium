class Recipes::Commoner < Rails::AppBuilder
  def ask
    if [:none, :None].include? get(:front_end)
      use_commoner = answer(:commoner) do
        Ask.confirm("Do you want ES6 to ES5 transpiling?")
      end
      set :commoner, use_commoner
    end
  end

  def create
    if ([:none, :None].include? get(:front_end)) && get(:commoner)
      gather_gem('sprockets-commoner')
      copy_file '../assets/config/initializers/sprockets_commoner.rb',
        'config/initializers/sprockets_commoner.rb'

      system 'yarn add babel-core@6 babel-preset-es2015 --save'

      copy_file '../assets/.babelrc', './.babelrc'
    end
  end

  def install
    create
  end

  def installed?
    gem_exists?(/sprockets-commoner/)
  end
end
