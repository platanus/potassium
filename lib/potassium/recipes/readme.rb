class Recipes::Readme < Rails::AppBuilder
  def create
    remove_file "README.md"
    template '../assets/README.md.erb', 'README.md'
    add_readme_header :installation
  end
end
