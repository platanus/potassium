class Recipes::FrontEndVite < Rails::AppBuilder
  def installed?
    gem_exists?(/vite_rails/)
  end

  def create
    add_vite
  end

  def install
    add_vite
  end

  def add_vite
    gather_gem("vite_rails")
    recipe = self
    after(:gem_install, wrap_in_action: :vite_install) do
      run "yarn install"
      run "bundle exec vite install"
    end
  end
end
