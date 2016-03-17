class Recipes::Editorconfig < Rails::AppBuilder
  def create
    copy_file '../assets/.editorconfig', '.editorconfig'
  end
end
