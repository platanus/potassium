class Recipes::Listen < Rails::AppBuilder
  def create
    gather_gems(:development) do
      gather_gem('listen')
    end
  end
end
