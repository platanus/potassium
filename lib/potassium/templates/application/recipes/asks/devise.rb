use_devise = Ask.confirm "Do you want to use Devise for authentication? (required for ActiveAdmin)"

if use_devise
  set(:authentication, :devise)

  create_user_model = Ask.confirm "Do you want to create a user model for Devise?"
  if create_user_model
    set(:authentication_model, :user)
  end
end
