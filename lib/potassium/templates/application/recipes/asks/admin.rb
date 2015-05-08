if equals?(:authentication, :devise)
  admin_mode = Ask.confirm "Do you want to use ActiveAdmin?"
  if admin_mode
    admin_mode = Ask.confirm "Do you really want to use ActiveAdmin?"
    if admin_mode
      admin_mode = Ask.confirm "Do you really, really want to use ActiveAdmin?"
    end
  end

  set(:admin_mode, admin_mode)
end
