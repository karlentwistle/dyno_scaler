# frozen_string_literal: true

require 'platform-api'

class DynoUpdateJob
  include Sidekiq::Job

  sidekiq_options queue: 'within_one_minute'

  def perform(review_app_id)
    return unless (review_app = ReviewApp.find_by(id: review_app_id))

    pipeline = review_app.pipeline

    heroku_client = PlatformAPI.connect_oauth(pipeline.api_key)
    formation = PlatformAPI::Formation.new(heroku_client)

    # TODO: need to check if its a no-op when requesting them same size
    # if it isnt a no-op, we need to check the current dyno size and exit if its already the optimal size
    formation.update(review_app.app_id, 'web', quantity: 1, size: review_app.optimal_size.code)
  end
end
