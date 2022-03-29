module Potassium
  class PlatanusConfig
    def initialize(options)
      @options = options
      @option_key_names = Potassium::CliOptions.option_names
    end

    def generate!
      default_options = {
        'db': 'postgresql', 'locale': 'es-CL', 'email_service': 'sendgrid', 'devise': true,
        'devise-user-model': true, 'admin': true, 'vue_admin': true, 'pundit': true,
        'api': 'rest', 'storage': 'shrine', 'heroku': true, 'background_processor': true,
        'draper': true, 'schedule': true, 'sentry': true, 'front_end': 'vue',
        'google_tag_manager': true, 'test': true, 'spring': true
      }
      default_options = default_options.filter { |key, _| @option_key_names.include?(key) }
      @options.merge(default_options, default_options.stringify_keys)
    end
  end
end
