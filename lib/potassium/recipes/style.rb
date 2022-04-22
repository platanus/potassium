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
      gather_gem 'rubocop', Potassium::RUBOCOP_VERSION
      gather_gem 'rubocop-performance'
      gather_gem 'rubocop-rails'
      gather_gem 'rubocop-rspec', Potassium::RUBOCOP_RSPEC_VERSION
      gather_gem 'rubocop-platanus'
    end

    after(:webpacker_install) do
      run "yarn add --dev stylelint eslint eslint-plugin-import "\
        "@typescript-eslint/eslint-plugin  @types/jest @typescript-eslint/parser eslint-plugin-jest"
      if selected?(:front_end, :vue)
        run 'yarn add --dev eslint-plugin-vue @vue/eslint-config-typescript'
      end
    end
  end

  def add_config_files
    copy_file '../assets/.rubocop.yml', '.rubocop.yml'
    copy_file '../assets/.eslintrc.json', '.eslintrc.json'
    copy_file '../assets/.stylelintrc.json', '.stylelintrc.json'
  end
end
