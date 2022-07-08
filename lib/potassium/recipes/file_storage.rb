class Recipes::FileStorage < Rails::AppBuilder
  def ask
    storages = {
      active_storage: 'ActiveStorage',
      shrine: 'Shrine',
      none: 'None, thanks'
    }

    storage = answer(:storage) do
      storages.keys[Ask.list('Which storage are you going to use?', storages.values)]
    end

    set(:storage, storage.to_sym)
  end

  def create
    add_chosen_storage
  end

  def install
    ask
    add_chosen_storage
  end

  def installed?
    file_exist?('config/storage.yml')
  end

  private

  def add_active_storage
    after(:gem_install) { run('bundle exec rails active_storage:install') }
    copy_file('../assets/config/storage.yml', 'config/storage.yml', force: true)
    active_storage_service_regexp = /config.active_storage.service = :local\n/
    gsub_file 'config/environments/production.rb', active_storage_service_regexp do
      'config.active_storage.service = :amazon'
    end
  end

  def add_shrine
    gather_gem('shrine', '~> 3.0')
    gather_gem('marcel', '~> 1.0')
    copy_file('../assets/config/shrine.rb', 'config/initializers/shrine.rb', force: true)
    copy_file('../assets/app/uploaders/image_uploader.rb', 'app/uploaders/image_uploader.rb')
    copy_file('../assets/app/uploaders/base_uploader.rb', 'app/uploaders/base_uploader.rb')
    append_to_file('.gitignore', "/public/uploads\n")
    add_image_handling_and_cover_image_uploader
  end

  def add_image_handling_and_cover_image_uploader
    gather_gem('image_processing', '~> 1.8')
    gather_gem('blurhash', '~> 0.1')
    gather_gem('ruby-vips', '~> 2.1')
    append_to_file('.env.development', "SHRINE_SECRET_KEY=#{SecureRandom.hex}\n")
    copy_file('../assets/app/jobs/shrine_promote_job.rb', 'app/jobs/shrine_promote_job.rb')
    add_image_handling_plugin
    add_cover_image_uploader
    add_image_handling_serializer_concern if get(:api)
    add_image_handling_heroku_setup if get(:heroku)
  end

  def add_cover_image_uploader
    copy_file(
      '../assets/app/uploaders/cover_image_uploader.rb', 'app/uploaders/cover_image_uploader.rb'
    )
    insert_into_file "config/routes.rb", after: "Rails.application.routes.draw do\n" do
      <<~HERE.indent(2)
        mount CoverImageUploader.derivation_endpoint => "/derivations/cover_image"
      HERE
    end
  end

  def add_image_handling_plugin
    copy_file(
      '../assets/config/initializers/shrine/plugins/image_handling_utilities.rb',
      'config/initializers/shrine/plugins/image_handling_utilities.rb'
    )
  end

  def add_image_handling_serializer_concern
    copy_file(
      '../assets/app/serializers/concerns/image_handling_attributes.rb',
      'app/serializers/concerns/image_handling_attributes.rb'
    )
    copy_file('../assets/app/serializers/base_serializer.rb', 'app/serializers/base_serializer.rb')
  end

  def add_image_handling_heroku_setup
    prepend_file(
      '.buildpacks',
      <<~HERE
        https://github.com/heroku/heroku-buildpack-apt
        https://github.com/brandoncc/heroku-buildpack-vips
      HERE
    )
    copy_file('../assets/Aptfile', 'Aptfile')
  end

  def common_setup
    gather_gem 'aws-sdk-s3', '~> 1.0'
    add_readme_section :internal_dependencies, get(:storage)
    append_to_file '.env.development', "S3_BUCKET=\n"
  end

  def add_chosen_storage
    return if [:none, :None].include? get(:storage).to_sym

    common_setup
    case get(:storage)
    when :active_storage
      add_active_storage
    when :shrine
      add_shrine
    end
  end
end
