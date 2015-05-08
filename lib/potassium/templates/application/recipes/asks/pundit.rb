if get(:authentication).present?
  use_pundit = multiple_choice("Do you want to use Pundit for authorization?", polar_choices)
  set(:authorization, :pundit) if use_pundit
end
