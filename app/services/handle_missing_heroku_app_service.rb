# frozen_string_literal: true

class HandleMissingHerokuAppService
  def initialize(review_app_id)
    @review_app_id = review_app_id
  end

  class ResponseResult
    def initialize(success, message = nil)
      @success = success
      @message = message
    end

    def success?
      @success
    end

    def failure?
      !@success
    end

    attr_reader :message
  end

  def call
    response = yield
    ResponseResult.new(true, response)
  rescue Excon::Error::NotFound
    JurassicDynoExtinctionCheckJob.perform_async(review_app_id)
    ResponseResult.new(false)
  end

  private

  attr_reader :review_app_id
end
