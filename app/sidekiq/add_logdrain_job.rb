# frozen_string_literal: true

require 'platform-api'

class AddLogdrainJob
  include Sidekiq::Job

  sidekiq_options queue: 'within_one_minute'

  def perform(pipeline_id)
    return unless (pipeline = Pipeline.find_by(id: pipeline_id))

    review_app_params = extract_review_app_params(pipeline)

    persisted_review_apps = ReviewApp.where(app_id: review_app_params.keys)

    new_review_app_ids = (review_app_params.keys - persisted_review_apps.map(&:app_id))
    new_review_apps = new_review_app_ids.map do |review_app_id|
      pipeline.review_apps.create!(app_id: review_app_id, **review_app_params[review_app_id])
    end

    batch_attach_log_drain(new_review_apps, persisted_review_apps)
  end

  private

  def extract_review_app_params(pipeline)
    PlatformAPI::ReviewApp
      .new(pipeline.platform_api)
      .list(pipeline.uuid)
      .to_h do |params|
      [params['app']['id'], params.slice('branch', 'pr_number')]
    end
  end

  def batch_attach_log_drain(*review_apps)
    Array
      .wrap(review_apps)
      .flatten
      .each { |review_app| attach_log_drain(review_app) }
  end

  def attach_log_drain(review_app)
    heroku_log_drain = PlatformAPI::LogDrain.new(review_app.platform_api_key)

    drain_urls = HandleMissingHerokuAppService.new(review_app.id).call do
      heroku_log_drain.list(review_app.app_id).pluck('url')
    end

    return unless drain_urls.success? && drain_urls.message.exclude?(review_app.logs_url)

    heroku_log_drain.create(review_app.app_id, url: review_app.logs_url)
  end
end
