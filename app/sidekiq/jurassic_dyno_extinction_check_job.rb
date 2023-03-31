# frozen_string_literal: true

class JurassicDynoExtinctionCheckJob
  include Sidekiq::Job

  def perform(id)
    return unless (review_app = ReviewApp.find_by(id:))

    begin
      PlatformAPI::ReviewApp
        .new(review_app.pipeline.platform_api)
        .get_review_app_by_app_id(review_app.app_id)
    rescue Excon::Error::Forbidden
      review_app.destroy!
    end
  end
end
