# frozen_string_literal: true

class BatchJurassicDynoExtinctionCheckJob
  include Sidekiq::Job

  sidekiq_options queue: 'within_one_minute'

  def perform
    ReviewApp.potentially_extinct.in_batches do |review_app_batch|
      JurassicDynoExtinctionCheckJob.perform_bulk(
        review_app_batch.pluck(:id).zip
      )
    end
  end
end
