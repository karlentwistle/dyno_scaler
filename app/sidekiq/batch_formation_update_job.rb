# frozen_string_literal: true

class BatchFormationUpdateJob
  include Sidekiq::Job

  sidekiq_options queue: 'within_one_minute'

  def perform
    ReviewApp.awaiting_update.in_batches do |review_app_batch|
      FormationUpdateJob.perform_bulk(
        review_app_batch.pluck(:id).zip
      )
    end
  end
end
