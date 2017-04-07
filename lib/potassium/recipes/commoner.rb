class Recipes::Commoner < Rails::AppBuilder
  def ask
    use_commoner = answer(:commoner) { Ask.confirm("Do you want to use ES6 to ES5 transpiling?") }
    set(:commoner, use_commoner)
  end

  def create
    if selected?(:commoner)
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
