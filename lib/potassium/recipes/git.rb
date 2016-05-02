class Recipes::Git < Rails::AppBuilder
  def create
    git :init
    after(:database_creation) do
      git add: "."
      git commit: %{ -m 'Initial commit' }
    end
  end
end
