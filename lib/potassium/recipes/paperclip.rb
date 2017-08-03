class Recipes::Paperclip < Rails::AppBuilder
  def ask
    paperclip = answer(:paperclip) { Ask.confirm("Do you want to use Paperclip for uploads?") }
    set(:paperclip, paperclip)
  end

  def create
    return unless selected?(:paperclip)
    add_paperclip
    config_rspec
  end

  def install
    add_paperclip
    config_rspec if gem_exists?(/rspec-rails/)
  end

  def installed?
    gem_exists?(/paperclip/)
  end

  private

  def add_paperclip
    gather_gem 'paperclip', '~> 5.0'
    paperclip_config =
      <<-RUBY.gsub(/^ {7}/, '')
         config.paperclip_defaults = {
           storage: :s3,
           s3_protocol: ENV['FORCE_SSL'] == 'true' ? 'https' : 'http',
           s3_region: ENV.fetch('AWS_REGION', 'us-east-1'),
           s3_credentials: {
             bucket: ENV['S3_BUCKET']
           }
         }
         RUBY
    application paperclip_config.strip, env: 'production'
    append_to_file '.env.development', "S3_BUCKET=\n"
    append_to_file '.gitignore', "/public/system/*\n"
    add_readme_section :internal_dependencies, :paperclip
  end

  def config_rspec
    copy_file '../assets/testing/platanus.png', 'spec/assets/platanus.png'
    copy_file '../assets/testing/paperclip.rb', 'spec/support/paperclip.rb'
  end
end
