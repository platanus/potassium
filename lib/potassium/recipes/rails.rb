class Recipes::Rails < Rails::AppBuilder
  def create
    gather_gem("bootsnap", require: false)
    gather_gems(:development) do
      gather_gem("spring")
    end

    environment 'config.force_ssl = true', env: 'production'

    line = "Rails.application.config.content_security_policy_nonce_generator = \
-> request { SecureRandom.base64(16) }"
    initializer = "config/initializers/content_security_policy.rb"
    gsub_file initializer, /(#{Regexp.escape(line)})/mi do |_match|
      <<~HERE.chomp
        # Rails.application.config.content_security_policy_nonce_generator = -> request do
        #   SecureRandom.base64(16)
        # end
      HERE
    end
  end
end
