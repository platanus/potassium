class Recipes::FileStorage < Rails::AppBuilder
  def ask
    storages = {
      active_storage: 'ActiveStorage',
      paperclip: '[DEPRECATED] Paperclip',
      none: 'None, thanks'
    }

    storage = answer(:storage) do
      storages.keys[Ask.list('Which storage are you going to use?', storages.values)]
    end

    set(:storage, storage.to_sym)
  end

  def create
    add_chosen_storage(check_rspec: false)
  end

  def install
    ask
    add_chosen_storage(check_rspec: true)
  end

  def installed?
    gem_exists?(/paperclip/) || file_exist?('config/storage.yml')
  end

  private

  def paperclip_config
    @paperclip_config ||=
      <<~RUBY
        config.paperclip_defaults = {
          storage: :s3,
          s3_protocol: 'https',
          s3_region: ENV.fetch('AWS_REGION', 'us-east-1'),
          s3_credentials: {
            bucket: ENV['S3_BUCKET']
          }
        }
      RUBY
  end

  def config_rspec_for_paperclip
    copy_file '../assets/testing/platanus.png', 'spec/assets/platanus.png'
    copy_file '../assets/testing/paperclip.rb', 'spec/support/paperclip.rb'
  end

  def add_paperclip
    gather_gem 'paperclip', '~> 5.0'
    application paperclip_config, env: 'production'
    append_to_file '.gitignore', "/public/system/*\n"
  end

  def add_active_storage
    after(:gem_install) { run('bundle exec rails active_storage:install') }
    copy_file('../assets/config/storage.yml', 'config/storage.yml', force: true)
    active_storage_service_regexp = /config.active_storage.service = :local\n/
    gsub_file 'config/environments/production.rb', active_storage_service_regexp do
      'config.active_storage.service = :amazon'
    end
  end

  def common_setup
    add_readme_section :internal_dependencies, get(:storage)
    append_to_file '.env.development', "S3_BUCKET=\n"
  end

  def add_chosen_storage(check_rspec:)
    return if get(:storage) == :none

    common_setup
    case get(:storage)
    when :paperclip
      add_paperclip
      config_rspec_for_paperclip if !check_rspec || gem_exists?(/rspec-rails/)
    when :active_storage
      add_active_storage
    end
  end
end
