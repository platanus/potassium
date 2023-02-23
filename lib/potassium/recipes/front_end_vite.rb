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
      recipe.copy_dotenv_monkeypatch
    end
  end

  def copy_dotenv_monkeypatch
    copy_file '../assets/lib/dotenv_monkeypatch.rb',
              'lib/dotenv_monkeypatch.rb', force: true
    insert_into_file(
      "config/application.rb",
      "\nrequire_relative '../lib/dotenv_monkeypatch'\n",
      after: "Bundler.require(*Rails.groups)"
    )
  end
end
