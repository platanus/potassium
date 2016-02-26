if get(:authentication).present?
  use_pundit = answer(:pundit) { Ask.confirm("Do you want to use Pundit for authorization?") }
  set(:authorization, :pundit) if use_pundit
end
