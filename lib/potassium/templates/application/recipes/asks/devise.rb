use_devise = answer(:devise) do
  Ask.confirm "Do you want to use Devise for authentication? (required for ActiveAdmin)"
end

if use_devise
  set(:authentication, :devise)

  create_user_model = answer(:"devise-user-model") do
    Ask.confirm "Do you want to create a user model for Devise?"
  end

  if create_user_model
    set(:authentication_model, :user)
  end
end
