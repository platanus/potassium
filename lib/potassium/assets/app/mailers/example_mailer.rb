class ExampleMailer < ApplicationMailer
  def example_mail
    @email = params[:email]
    mail(from: 'admin@example.com', to: @email, subject: 'Welcome to Potassium')
  end
end
