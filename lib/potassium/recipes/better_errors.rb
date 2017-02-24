class Recipes::BetterErrors < Rails::AppBuilder
  def create
    gather_gems(:development, :test) do
      gather_gem('better_errors')
      gather_gem('binding_of_caller')
    end
  end
end
