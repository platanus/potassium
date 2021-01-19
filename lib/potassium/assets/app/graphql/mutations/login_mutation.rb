require 'jwt'

class Mutations::LoginMutation < Mutations::BaseMutation
  null true

  argument :email, String, required: true
  argument :password, String, required: true


  field :token, String, null: true

  def resolve(email:, password:)
    user = User.find_by(email: email)
    if user&.valid_password?(password)
      payload = { id: user.id, email: user.email, exp: (Time.zone.now + 24.hours).to_i }
      token = JWT.encode payload, ENV['HMAC_SECRET'], 'HS256'
      return { token: token }
    end
    GraphQL::ExecutionError.new("User or Password invalid")
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end
