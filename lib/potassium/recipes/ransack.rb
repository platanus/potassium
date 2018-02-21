class Recipes::Ransack < Rails::AppBuilder
  def ask
    ransack = answer(:ransack) do
      Ask.confirm('Do you want to use Ransack for custom search functionality?')
    end
    set(:ransack, ransack)
  end

  def create
    return unless selected?(:ransack)
    add_ransack
  end

  private

  def add_ransack
    gather_gem 'ransack'
    add_readme_section :internal_dependencies, :ransack
  end
end
