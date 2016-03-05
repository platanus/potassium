class Recipes::Readme < Recipes::Base
  def create
    t.remove_file "README.md"
    t.template "assets/README.md.erb", "README.md"
  end
end
