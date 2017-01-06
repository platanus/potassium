class Recipes::Seeds < Rails::AppBuilder
  def create
    recipe = self
    copy_env_seed_file

    if selected?(:admin_mode)
      after(:admin_install, wrap_in_action: :seeds_config) do
        recipe.override_seed_files
      end
    end
  end

  def install
    copy_env_seed_file
    admin = load_recipe(:admin)
    override_seed_files if admin.installed?
  end

  def copy_env_seed_file
    copy_file '../assets/seeds/seeds.rb', 'db/seeds.rb', force: true
    copy_file '../assets/seeds/common.rb', 'db/seeds/common.rb'
    copy_file '../assets/seeds/development.rb', 'db/seeds/development.rb'
    copy_file '../assets/seeds/production.rb', 'db/seeds/production.rb'
  end

  def override_seed_files
    copy_file '../assets/seeds/seeds.rb', 'db/seeds.rb', force: true
    copy_file '../assets/seeds/admin_development.rb', 'db/seeds/development.rb', force: true
  end
end
