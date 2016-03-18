class Recipes::Git < Rails::AppBuilder
  def create
    git :init
    after(:database_creation) do
      append_to_file '.gitignore', ".env\n"
      append_to_file '.gitignore', ".powder\n"
      append_to_file '.gitignore', "vendor/assets/bower_components\n"

      git add: "."
      git commit: %{ -m 'Initial commit' }
    end
  end
end
