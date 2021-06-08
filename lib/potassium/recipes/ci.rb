class Recipes::Ci < Rails::AppBuilder
  def create
    template '../assets/.circleci/config.yml.erb', '.circleci/config.yml'

    gather_gems(:test) do
      gather_gem 'rspec_junit_formatter', '0.2.2'
    end

    add_readme_header :ci
    application 'config.assets.js_compressor = :uglifier', env: 'test'
  end

  private

  def ruby_version
    Semantic::Version.new(Potassium::RUBY_VERSION).instance_eval { "#{major}.#{minor}" }
  end
end
