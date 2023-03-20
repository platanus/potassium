class Recipes::Editorconfig < Rails::AppBuilder
  def create
    copy_file '../assets/.editorconfig', '.editorconfig'
    copy_file '../assets/.vscode/recommended-settings.json', '.vscode/recommended-settings.json'
    copy_file '../assets/.vscode/extensions.json', '.vscode/extensions.json'
    add_readme_section :vscode
  end
end
