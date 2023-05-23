class Recipes::Ci < Rails::AppBuilder
  def create
    template '../assets/.circleci/config.yml.erb', '.circleci/config.yml'
    gather_gem 'repo_analyzer'

    gather_gems(:test) do
      gather_gem 'rspec_junit_formatter', '~> 0.4'
    end

    gather_gems(:development, :test) do
      gather_gem('brakeman')
    end

    add_readme_header :ci
    application 'config.assets.js_compressor = :uglifier', env: 'test'
  end

  def install
    create
  end

  def installed?
    file_exist?('.circleci/config.yml')
  end
end
