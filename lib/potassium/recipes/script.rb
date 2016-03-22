class Recipes::Script < Rails::AppBuilder
  def create
    template "../assets/bin/setup.erb", "bin/setup", force: true
    run "chmod a+x bin/setup"
  end

  def install
    heroku = load_recipe(:heroku)
    set(:heroku, heroku.installed?)
    create
  end

  def installed?
    file_exist?("bin/setup")
  end
end
