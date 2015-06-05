module ApiErrorConcern
  extend ActiveSupport::Concern

  included do
    rescue_from "Exception" do |exc|
      logger.error exc.message
      logger.error exc.backtrace.join("\n")
      api_respond_error(:internal_server_error, {
        msg: "server_error",
        type: exc.class.to_s,
        detail: exc.message
      })
    end

    rescue_from "ActiveRecord::RecordNotFound" do |exc|
      api_respond_error(:not_found, {
        msg: "record_not_found",
        detail: exc.message
      })
    end

    rescue_from "ActiveModel::ForbiddenAttributesError" do |exc|
      api_respond_error(:bad_request, {
        msg: "protected_attributes",
        detail: exc.message
      })
    end

    rescue_from "ActiveRecord::RecordInvalid" do |exc|
      api_respond_error(:bad_request, {
        msg: "invalid_attributes",
        errors: exc.record.errors
      })
    end
  end

  def api_respond_error(_status, _error_obj = {})
    render json: _error_obj, status: _status
  end
end
