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
      serializer_class.new(resource, options)
    else
      resource
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
end
