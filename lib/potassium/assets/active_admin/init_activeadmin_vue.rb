module AdminPageLayoutOverride
  def build_page(*args)
    within head do
      text_node(javascript_packs_with_chunks_tag('admin_application'))
    end
    super
  end
end

ActiveAdmin::Views::Pages::Base.send :prepend, AdminPageLayoutOverride
