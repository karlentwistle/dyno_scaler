# frozen_string_literal: true

class LogsController < ActionController::Metal
  include ActionController::HttpAuthentication::Basic::ControllerMethods

  def create
    if (review_app = authenticate)
      process_request(review_app)

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

  def process_request(review_app)
    heroku_logs = HerokuLogParser.parse(request.body.read)

    return if heroku_logs.none? { |log| log[:proc_id] == 'router' }

    review_app.request_received
  end
end
