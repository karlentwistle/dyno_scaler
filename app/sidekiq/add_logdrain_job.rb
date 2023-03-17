# frozen_string_literal: true

require 'platform-api'

class AddLogdrainJob
  include Sidekiq::Job

  def perform(pipeline_id)
    return unless (pipeline = Pipeline.find_by(id: pipeline_id))

    heroku_client = PlatformAPI.connect_oauth(pipeline.api_key)
    heroku_review_app = PlatformAPI::ReviewApp.new(heroku_client)
    heroku_log_drain = PlatformAPI::LogDrain.new(heroku_client)

    review_apps = heroku_review_app.list(pipeline.uuid)

    review_apps.each do |review_app|
      app_id = review_app.fetch('app').fetch('id')
      drain_urls = heroku_log_drain.list(app_id).pluck('url')

      dyno = pipeline.dynos.find_or_create_by!(app_id:)
      heroku_log_drain.create(app_id, url: dyno.logs_url) if drain_urls.exclude?(dyno.logs_url)
    end
  end
end
