class Recipes::Style < Rails::AppBuilder
  def create
    copy_file '../assets/.rubocop.yml', '.rubocop.yml'
    copy_file '../assets/.ruby_style.yml', '.ruby_style.yml'
    copy_file '../assets/.hound.yml', '.hound.yml'

    append_to_file '.gitignore', '.rubocop-http*\n'
  end

  def install
    create
  end
end
