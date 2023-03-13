# frozen_string_literal: true

class LogsController < ActionController::Metal
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  def create
    if authenticate
      self.status = 201
    else
      request_http_basic_authentication
    end
  end

  private

  def authenticate
    authenticate_with_http_basic do |given_name, given_password|
      ActiveSupport::SecurityUtils.secure_compare(given_name.to_s, 'username') &
        ActiveSupport::SecurityUtils.secure_compare(given_password.to_s, 'password')
    end
  end
end
