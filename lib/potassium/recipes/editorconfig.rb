class Recipes::Editorconfig < Recipes::Base
  def create
    t.copy_file '../assets/.editorconfig', '.editorconfig'
  end
end
