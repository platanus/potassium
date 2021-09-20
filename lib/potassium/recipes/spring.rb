class Recipes::Spring < Rails::AppBuilder
  def create
    if answer(:spring)
      gather_gems(:development) do
        gather_gem("spring")
      end
    end
  end
end
