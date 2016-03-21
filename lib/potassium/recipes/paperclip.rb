class Recipes::Paperclip < Rails::AppBuilder
  def ask
    paperclip = answer(:paperclip) { Ask.confirm("Do you want to use Paperclip for uploads?") }
    set(:paperclip, paperclip)
  end

  def create
    add_paperclip if selected?(:paperclip)
  end

  def install
    if gem_exists?(/paperclip/)
      info "Paperclip is already installed"
    else
      add_paperclip
    end
  end

  def add_paperclip
    gather_gem 'paperclip', '~> 4.3'
    paperclip_config =
      <<-RUBY.gsub(/^ {7}/, '')
         config.paperclip_defaults = {
           storage: :s3,
           s3_credentials: {
             bucket: ENV['AWS_BUCKET']
           }
         }
         RUBY
    application paperclip_config.strip, env: 'production'
    append_to_file '.env.example', 'AWS_BUCKET='
    append_to_file '.env', 'AWS_BUCKET='
    add_readme_section :internal_dependencies, :paperclip
  end
end
