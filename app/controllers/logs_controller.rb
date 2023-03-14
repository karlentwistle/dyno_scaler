# frozen_string_literal: true

class LogsController < ActionController::Metal
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  def create
    if (dyno = authenticate)
      dyno.request_received
      self.status = 201
    else
      request_http_basic_authentication
    end
  end

  private

  def authenticate
    authenticate_with_http_basic do |_given_name, given_password|
      Dyno.authenticate(given_password)
    end
  end
end
