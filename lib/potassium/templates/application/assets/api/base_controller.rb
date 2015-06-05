class Api::V1::BaseController < ApplicationController
  self.responder = ApiResponder

  respond_to :json
end
