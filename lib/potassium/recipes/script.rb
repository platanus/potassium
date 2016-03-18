class Recipes::Script < Rails::AppBuilder
  def create
    template "../assets/bin/setup.erb", "bin/setup", force: true
    run "chmod a+x bin/setup"
  end

  def install
    if file_exist?("bin/setup") && !force?
      set(:heroku, true)
      load_recipe(:heroku)
    end
    create
  end
end
