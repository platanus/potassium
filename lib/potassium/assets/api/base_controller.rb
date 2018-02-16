class Api::V1::BaseController < ApplicationController
  before_action do
    self.namespace_for_serializer = ::V1
  end

  include ApiErrorConcern
  include ApiVersioned
  include ApiDeprecated
  include ApiPaged

  self.responder = ApiResponder

  respond_to :json
end
