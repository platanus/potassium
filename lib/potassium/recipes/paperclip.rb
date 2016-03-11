class Recipes::Paperclip < Recipes::Base
  def ask
    paperclip = t.answer(:paperclip) { Ask.confirm("Do you want to use Paperclip for uploads?") }
    t.set(:paperclip, paperclip)
  end

  def create
    add_paperclip if t.selected?(:paperclip)
  end

  def install
    if t.gem_exists?(/paperclip/)
      t.info "Paperclip is already installed"
    else
      add_paperclip
    end
  end

  def add_paperclip
    t.gather_gem 'paperclip', '~> 4.3'
    paperclip_config = %{
    config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
        :bucket => ENV['AWS_BUCKET']
      }
    }
    }
    t.application paperclip_config.strip, env: 'production'
    t.append_to_file '.env.example', 'AWS_BUCKET='
    t.append_to_file '.env', 'AWS_BUCKET='
  end
end
