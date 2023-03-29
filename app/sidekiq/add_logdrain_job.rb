# frozen_string_literal: true

require 'platform-api'

class AddLogdrainJob
  include Sidekiq::Job

  sidekiq_options queue: 'within_one_minute'

  def perform(pipeline_id)
    return unless (pipeline = Pipeline.find_by(id: pipeline_id))

    heroku_review_app = PlatformAPI::ReviewApp.new(pipeline.platform_api)
    heroku_log_drain = PlatformAPI::LogDrain.new(pipeline.platform_api)
    review_apps = heroku_review_app.list(pipeline.uuid)

    review_apps.each do |review_app|
      app_id = review_app.fetch('app').fetch('id')
      drain_urls = heroku_log_drain.list(app_id).pluck('url')

      review_app = pipeline.review_apps.find_or_create_by!(app_id:)
      heroku_log_drain.create(app_id, url: review_app.logs_url) if drain_urls.exclude?(review_app.logs_url)
    end
  end
end
