if equals?(:authentication, :devise)
  admin_mode = Ask.confirm "Do you want to use ActiveAdmin?"

  set(:admin_mode, admin_mode)
end
