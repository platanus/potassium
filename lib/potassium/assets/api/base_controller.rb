class Api::V1::BaseController < ApplicationController
  if Rails.env.production?
    include ApiErrorConcern
  end

  self.responder = ApiResponder

  respond_to :json
end
