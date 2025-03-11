# frozen_string_literal: true

class BatchAddLogdrainJob
  include Sidekiq::Job

  sidekiq_options queue: 'within_one_minute'

  def perform
    Pipeline.in_batches do |pipeline_batch|
      AddLogdrainJob.perform_bulk(
        pipeline_batch.pluck(:id).zip
      )
    end
  end
end
