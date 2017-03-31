class Recipes::Commoner < Rails::AppBuilder
  def create
    gather_gem('sprockets-commoner')
    copy_file '../assets/config/initializers/sprockets_commoner.rb',
      'config/initializers/sprockets_commoner.rb'

    `yarn add babel-core@6 babel-preset-es2015 --save`

    copy_file '../assets/.babelrc', './.babelrc'
  end

  def install
    create
  end
end
