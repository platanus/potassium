class ApiResponder < ActionController::Responder
  def respond
    return display_errors if has_errors?
    return head(:no_content) if delete?

    display(resource, status: status_code)
  end

  private

  def display(resource, given_options = {})
    options[:json] = resource
    controller.render(options.merge(given_options))
  end

  def status_code
    return :created if post?
    :ok
  end

  def display_errors
    error = {
      code: 400,
      status: "error",
      message: "invalid_attributes",
      data: resource.errors.as_json
    }

    controller.render(status: :bad_request, json: error)
  end

  def format_errors
    resource.errors.as_json
  end
end
