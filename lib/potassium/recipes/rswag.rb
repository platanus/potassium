class Recipes::Rswag < Rails::AppBuilder
  def ask
    return unless selected?(:api_support)
    rswag = answer(:rswag) do
      Ask.confirm('Do you want to use Rswag to generate API documentation?')
    end
    set(:rswag, rswag)
  end

  def create
    if selected?(:rswag)
      add_rswag
      run_generator
    end
  end

  def installed?
    gem_exists?(/rswag/)
  end

  private

  def add_rswag
    gather_gem('rswag-ui')
    gather_gem('rswag-api')
    gather_gems(:development, :test) do
      gather_gem('rswag-specs')
    end
    add_readme_section :internal_dependencies, :rswag
  end

  def run_generator
    after(:gem_install) do
      generate "rswag:ui:install"
      generate "rswag:api:install"
      generate "rswag:specs:install"
    end
  end
end
