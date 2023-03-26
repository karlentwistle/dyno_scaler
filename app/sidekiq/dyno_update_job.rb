# frozen_string_literal: true

require 'platform-api'

class DynoUpdateJob
  include Sidekiq::Job

  sidekiq_options queue: 'within_one_minute'

  def perform(dyno_id)
    return unless (dyno = Dyno.find_by(id: dyno_id))

    pipeline = dyno.pipeline

    heroku_client = PlatformAPI.connect_oauth(pipeline.api_key)
    formation = PlatformAPI::Formation.new(heroku_client)

    # TODO: need to check if its a no-op when requesting them same size
    # if it isnt a no-op, we need to check the current dyno size and exit if its already the optimal size
    formation.update(dyno.app_id, 'web', quantity: 1, size: dyno.optimal_size.code)
  end
end
