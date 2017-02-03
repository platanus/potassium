class ApiResponder < ActionController::Responder
  def respond
    return display_errors if has_errors?
    return head :no_content if delete?

    display resource, status_code: status_code
  end

  private

  def display(_resource, given_options = {})
    controller.render options.merge(given_options).merge(
      json: serializer.as_json
    )
  end

  def serializer
    serializer_class = ActiveModel::Serializer.serializer_for(resource)
    if serializer_class.present?
      serializer_options = infer_serializer(serializer_class).merge(options)
      serializer_class.new(decorated_resource, serializer_options)
    else
      decorated_resource
    end
  end

  def status_code
    return :created if post?
    :ok
  end

  def display_errors
    controller.render(
      status: :unprocessable_entity,
      json: { msg: "invalid_attributes", errors: format_errors }
    )
  end

  def format_errors
    resource.errors.as_json
  end

  def infer_serializer(serializer_class)
    if serializer_class == ActiveModel::ArraySerializer
      s = options.delete(:each_serializer) || "#{resource.klass}Serializer".constantize
      { each_serializer: s }
    else
      s = options.delete(:serializer) || "#{resource.class}Serializer".constantize
      { serializer: s }
    end
  end

  def decorated_resource
    if resource.respond_to?(:decorate)
      resource.decorate
    else
      resource
    end
  rescue Draper::UninferrableDecoratorError
    resource
  end
end
