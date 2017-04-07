# Devise async email feature override
module Devise
  mattr_accessor :mailer_deliver_later
  @@mailer_deliver_later = false
  module Models
    alias_method :original_devise, :devise
    def devise(*modules)
      if Rails.application.config.devise.try(:mailer_deliver_later)
        define_method(:send_devise_notification) do |notification, *args|
          devise_mailer.send(notification, self, *args).deliver_later
        end
      end
      original_devise(*modules)
    end
  end
end

