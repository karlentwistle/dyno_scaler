# frozen_string_literal: true

require 'platform-api'

class FormationUpdateJob
  include Sidekiq::Job

  sidekiq_options queue: 'within_one_minute'

  def perform(review_app_id)
    return unless (review_app = ReviewApp.find_by(id: review_app_id))

    pipeline = review_app.pipeline

    heroku_client = PlatformAPI.connect_oauth(pipeline.api_key)
    formation = PlatformAPI::Formation.new(heroku_client)

    formation.update(review_app.app_id, 'web', quantity: 1, size: review_app.optimal_size.code)
  end
end
