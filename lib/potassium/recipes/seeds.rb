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
    copy_file '../assets/seeds/fake_data_loader.rb', 'lib/fake_data_loader.rb'
    copy_file '../assets/seeds/fake_data_loader.rake', 'lib/tasks/db/fake_data.rake'
    add_readme_header :seeds
  end

  def override_seed_files
    copy_file '../assets/seeds/seeds.rb', 'db/seeds.rb', force: true
    copy_file '../assets/seeds/admin_data_loader.rb', 'lib/fake_data_loader.rb', force: true
  end
end
