# frozen_string_literal: true

class JurassicDynoExtinctionCheckJob
  include Sidekiq::Job

  sidekiq_options queue: 'within_one_minute'

  def perform(id)
    return unless (review_app = ReviewApp.find_by(id:))

    begin
      PlatformAPI::ReviewApp
        .new(review_app.platform_api_key)
        .get_review_app_by_app_id(review_app.app_id)
    rescue Excon::Error::Forbidden
      review_app.destroy!
    rescue Excon::Error::Timeout => e
      raise Errors::RetryWithoutReporting, e.message
    end
  end
end
