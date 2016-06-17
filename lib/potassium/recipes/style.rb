class Recipes::Style < Rails::AppBuilder
  def create
    append_to_file '.gitignore', ".rubocop.yml\n"
    append_to_file '.gitignore', ".eslintrc.json\n"
    append_to_file '.gitignore', ".sscs-lint.yml\n"
    add_readme_header :style_guide
  end

  def install
    create
  end
end
