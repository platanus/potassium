class ActiveAdmin::Views::Pages::Base
  alias_method :old_add_classes_to_body, :add_classes_to_body

  def add_classes_to_body
    old_add_classes_to_body
    @body.set_attribute "ng-app", "ActiveAdmin"
  end
end
