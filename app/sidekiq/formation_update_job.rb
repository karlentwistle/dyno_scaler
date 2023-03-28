# frozen_string_literal: true

require 'platform-api'

class FormationUpdateJob
  include Sidekiq::Job

  sidekiq_options queue: 'within_one_minute'

  def perform(review_app_id)
    return unless (review_app = ReviewApp.find_by(id: review_app_id))

    return if review_app.optimal_size?

    begin
      response = update_formation(review_app)
      review_app.update!(current_size: DynoSize.find_by(name: response['size']))
    rescue Excon::Error::NotFound
      review_app.destroy!
    end
  end

  private

  def formation_update_client(pipeline)
    heroku_client = PlatformAPI.connect_oauth(pipeline.api_key)
    PlatformAPI::Formation.new(heroku_client)
  end

  def update_formation(review_app)
    formation_update_client(review_app.pipeline)
      .update(
        review_app.app_id,
        'web',
        quantity: 1,
        size: review_app.optimal_size.name
      )
  end
end
