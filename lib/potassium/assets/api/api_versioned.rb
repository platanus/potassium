module Api::Versioned
  extend ActiveSupport::Concern

  AVAILABLE_API_VERSIONS = 1

  included do
    before_action :check_api_version!
    after_action :set_content_type
  end

  private

  def check_api_version!
    accept_header = request.headers[:accept]
    @version_number = accept_header.to_s.match(/version=(\d+)/).try(:captures).try(:first).to_i
    @version_number = 1 if @version_number.zero?
    fail "invalid API version" unless (1..AVAILABLE_API_VERSIONS) === @version_number
  end

  def set_content_type
    content_type_header = response.headers["Content-Type"]
    parts = !content_type_header ? [] : content_type_header.split(";").map(&:strip)
    parts << "version=#{@version_number}"
    response.headers["Content-Type"] = parts.join("; ")
  end
end
