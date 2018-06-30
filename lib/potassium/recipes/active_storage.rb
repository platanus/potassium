class Recipes::ActiveStorage < Rails::AppBuilder
  def ask
    active_storage = answer(:active_storage) do
      Ask.confirm("Do you want to use ActiveStorage for uploads?")
    end

    set(:active_storage, active_storage)
  end

  def create
    return unless selected?(:active_storage)
    add_active_storage
  end

  def install
    add_active_storage
  end

  def installed?
    file_exist?('config/storage.yml')
  end

  private

  def add_active_storage
    after(:gem_install) { run("bundle exec rails active_storage:install") }

    add_readme_section :internal_dependencies, :storage

    copy_file("../assets/config/storage.yml", "config/storage.yml", force: true)

    append_to_file '.env.development', "AWS_REGION=\n"
    append_to_file '.env.development', "S3_BUCKET=\n"

    raise_delivery_errors_regexp = /config.active_storage.service = :local\n/
    gsub_file 'config/environments/production.rb', raise_delivery_errors_regexp do
      "config.active_storage.service = :amazon"
    end
  end
end
