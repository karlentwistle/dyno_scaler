# frozen_string_literal: true

module PipelineHelper
  def polling_interval_milliseconds
    (Rails.application.config.x.polling_interval_seconds * 1000).to_i
  end
end
