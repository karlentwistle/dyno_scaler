# frozen_string_literal: true

class LogsController < ActionController::Metal
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  def create
    if (review_app = authenticate)
      review_app.request_received
      self.status = 201
    else
      request_http_basic_authentication
    end
  end

  private

  def authenticate
    authenticate_with_http_basic do |_given_name, given_password|
      ReviewApp.authenticate(given_password)
    end
  end
end
