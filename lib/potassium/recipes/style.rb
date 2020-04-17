class Recipes::Style < Rails::AppBuilder
  def create
    add_linters
    add_config_files
    add_readme_header :style_guide
  end

  def install
    create
  end

  private

  def add_linters
    gather_gems(:development, :test) do
      gather_gem 'rubocop', '~> 0.82.0'
      gather_gem 'rubocop-performance'
      gather_gem 'rubocop-rails'
      gather_gem 'rubocop-rspec'
    end
    run 'bin/yarn add --dev stylelint eslint eslint-plugin-import'
    run 'bin/yarn add --dev eslint-plugin-vue' if selected?(:front_end, :vue)
  end

  def add_config_files
    copy_file '../assets/.rubocop.yml', '.rubocop.yml'
    copy_file '../assets/.eslintrc.json', '.eslintrc.json'
    copy_file '../assets/.stylelintrc.json', '.stylelintrc.json'
  end
end
