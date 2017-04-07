
# Override devise to send email via jobs
module Devise
  module Models
    alias_method :original_devise, :devise
    def devise(*modules)
      if modules.include? :job_emailable
        define_method(:send_devise_notification) do |notification, *args|
          devise_mailer.send(notification, self, *args).deliver_later
        end
      end
      modules.delete :job_emailable
      original_devise(*modules)
    end
  end
end
