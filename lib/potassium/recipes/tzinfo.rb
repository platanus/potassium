class Recipes::Tzinfo < Rails::AppBuilder
  def create
    gather_gems(:production, :development, :test) do
      gather_gem("tzinfo-data")
    end
  end
end
