module ApiErrorConcern
  extend ActiveSupport::Concern

  included do
    rescue_from "Exception" do |exception|
      logger.error exception.message
      logger.error exception.backtrace.join("\n")
      respond_api_error(500, "server_error", exception.class.to_s)
    end

    rescue_from "ActionController::UnknownFormat" do |exception|
      respond_api_error(404, "unknown_format", exception.class.to_s)
    end

    rescue_from "ActiveRecord::RecordNotFound" do |exception|
      respond_api_error(404, "record_not_found", exception.class.to_s)
    end

    rescue_from "ActiveModel::ForbiddenAttributesError" do |exception|
      respond_api_error(400, "protected_attributes", exception.class.to_s)
    end

    rescue_from "ActiveRecord::RecordInvalid" do |exception|
      respond_api_error(400, "invalid_attributes", exception.record.errors)
    end

    rescue_from "ApiVersionError" do
      data = ["application/json; version=1", "application/json; version=2"]
      respond_api_error(406, "invalid_api_version", data)
    end
  end

  def respond_api_error(code, message, data)
    error = {
      code: code,
      status: code >= 500 ? "fail" : "error",
      message: message,
      data: data
    }

    render json: error, status: code
  end
end
