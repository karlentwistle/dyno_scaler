# frozen_string_literal: true

require 'platform-api'

class AddLogdrainToPipelineDynosJob
  include Sidekiq::Job

  def perform(pipeline_id)
    return unless (pipeline = Pipeline.find_by(id: pipeline_id))

    client = PlatformAPI.connect_oauth(pipeline.api_key)

    review_apps = PlatformAPI::ReviewApp.new(client).list(pipeline.uuid)

    review_apps.each do |review_app|
      app_id = review_app.fetch('app').fetch('id')
      log_drain = PlatformAPI::LogDrain.new(client)
      drains = log_drain.list(app_id)
      dyno = pipeline.dynos.find_or_create_by!(app_id:)

      log_drain.create(app_id, url: dyno.logs_url) if drains.none? { |d| d['url'] == dyno.logs_url }
    end
  end
end
