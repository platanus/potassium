class Api::V1::BaseController < ApplicationController
  include ApiErrorConcern

  self.responder = ApiResponder

  respond_to :json
end
