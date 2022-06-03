module Potassium
  class PlatanusConfig
    def initialize(options)
      @options = options
      @option_key_names = Potassium::CliOptions.option_names
    end

    def generate!
      default_options = {
        'db': 'postgresql', 'locale': 'es-CL', 'email_service': 'aws_ses', 'devise': false,
        'devise-user-model': false, 'admin': false, 'vue_admin': false, 'pundit': false,
        'api': false, 'storage': 'shrine', 'heroku': true, 'background_processor': true,
        'draper': false, 'schedule': false, 'sentry': false, 'front_end': 'None',
        'google_tag_manager': false, 'test': false, 'spring': false, 'review_apps': true,
        'github': true
      }
      default_options = default_options.filter { |key, _| @option_key_names.include?(key) }
      @options.merge(default_options, default_options.stringify_keys)
    end
  end
end
