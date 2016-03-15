class Recipes::Style < Recipes::Base
  def create
    t.copy_file '../assets/.rubocop.yml', '.rubocop.yml'
    t.copy_file '../assets/.ruby_style.yml', '.ruby_style.yml'
    t.copy_file '../assets/.hound.yml', '.hound.yml'

    t.append_to_file '.gitignore', '.rubocop-http*\n'
  end

  def install
    create
  end
end
