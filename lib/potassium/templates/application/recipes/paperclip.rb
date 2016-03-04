class Recipes::Paperclip < Recipes::Base
  def ask
    self.selected = t.answer(:paperclip) do
      Ask.confirm("Do you want to use Paperclip for uploads?")
    end
  end

  def create
    add_paperclip if selected?
  end

  def install
    add_paperclip
  end

  private

  attr_accessor :selected
  alias_method :selected?, :selected

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
