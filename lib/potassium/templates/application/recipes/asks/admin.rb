if selected?(:authentication, :devise)
  admin_mode = answer(:admin) { Ask.confirm("Do you want to use ActiveAdmin?") }
  if admin_mode
    angular_admin = answer(:"angular-admin") do
      Ask.confirm "Do you want Angular support for ActiveAdmin?"
    end
    set(:angular_admin, angular_admin)
  end

  set(:admin_mode, admin_mode)
end
