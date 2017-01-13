class Recipes::Annotate < Rails::AppBuilder
  def create
    gather_gems(:development) do
      gather_gem('annotate')
    end

    template '../assets/lib/tasks/auto_annotate_models.rake',
      'lib/tasks/auto_annotate_models.rake'
  end

  def install
    create
  end
end
