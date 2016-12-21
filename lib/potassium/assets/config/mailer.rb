Rails.application.config.action_mailer.raise_delivery_errors = false
Rails.application.config.action_mailer.delivery_method = :<%= get(:mailer_delivery_method) %>

Rails.application.config.action_mailer.default_url_options = {
  host: ENV.fetch('APPLICATION_HOST'),
  protocol: ENV['FORCE_SSL'] == 'true' ? 'https' : 'http'
}

Rails.application.config.action_mailer.default_options = { from: ENV['DEFAULT_EMAIL_ADDRESS'] }
ASSET_HOST = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))
Rails.application.config.action_mailer.asset_host = ASSET_HOST

if ENV["EMAIL_RECIPIENTS"].present?
  Mail.register_interceptor RecipientInterceptor.new(
    ENV["EMAIL_RECIPIENTS"],
    subject_prefix: "[#{Heroku.stage.upcase}]"
  )
end
