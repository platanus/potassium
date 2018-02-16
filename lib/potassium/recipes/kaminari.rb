class Recipes::Kaminari < Rails::AppBuilder
  def ask
    kaminari = answer(:kaminari) do
      Ask.confirm("Do you want to install Kaminari?")
    end

    if kaminari
      set(:kaminari, kaminari)
    end
  end

  def create
    add_kaminari if get(:kaminari)
  end

  def install
    add_kaminari
  end

  def add_kaminari
    gather_gem 'kaminari'
    add_readme_section :internal_dependencies, :kaminari

    after(:gem_install) do
      generate "kaminari:config"
    end
  end

  def installed?
    gem_exists?(/kaminari/)
  end
end
