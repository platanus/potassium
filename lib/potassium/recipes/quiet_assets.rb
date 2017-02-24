class Recipes::QuietAssets < Rails::AppBuilder
  def create
    gather_gems(:development, :test) do
      gather_gem('quiet_assets')
    end
  end
end
