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

    review_apps.each do |review_app_params|
      review_app = find_or_create_review_app(pipeline, review_app_params)

      drain_urls = HandleMissingHerokuAppService.new(review_app.id).call do
        heroku_log_drain.list(review_app.app_id).pluck('url')
      end

      next unless drain_urls.success? && drain_urls.message.exclude?(review_app.logs_url)

      heroku_log_drain.create(review_app.app_id, url: review_app.logs_url)
    end
  end

  private

  def find_or_create_review_app(pipeline, params)
    app_id = params.dig('app', 'id')
    branch = params['branch']
    pr_number = params['pr_number']

    pipeline.review_apps.find_or_create_by!(app_id:) do |new_review_app|
      new_review_app.branch = branch
      new_review_app.pr_number = pr_number
    end
  end
end
