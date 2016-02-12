if selected?(:paperclip)
  gather_gem('paperclip', '~> 4.3')

  paperclip_config = %{
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV['AWS_BUCKET']
    }
  }
  }

  application paperclip_config.strip, env: 'production'

  append_to_file '.env.example', 'AWS_BUCKET='
  append_to_file '.env', 'AWS_BUCKET='
end
