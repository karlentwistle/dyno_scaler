# frozen_string_literal: true

require 'platform-api'

class FormationUpdateJob
  include Sidekiq::Job

  sidekiq_options queue: 'within_one_minute'

  def perform(review_app_id)
    return unless (review_app = ReviewApp.find_by(id: review_app_id))

    return if review_app.optimal_size?

    response = HandleMissingHerokuAppService.new(review_app.id).call do
      update_formation(review_app)
    end

    return if response.failure?

    persist_new_size(review_app, response.message['size'])
  end

  private

  def persist_new_size(review_app, new_size)
    update_env_vars(review_app, new_size) if review_app.pipeline.set_env?
    review_app.update!(current_size: DynoSize.find_by(name: new_size))
  end

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

  def env_vars_update_client(pipeline)
    heroku_client = PlatformAPI.connect_oauth(pipeline.api_key)
    PlatformAPI::ConfigVar.new(heroku_client)
  end

  def update_env_vars(review_app, size)
    env_vars_update_client(review_app.pipeline)
      .update(
        review_app.app_id,
        'DYNO_SCALER_DYNO_SIZE' => size
      )
  end
end
