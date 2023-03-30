# frozen_string_literal: true

return unless ENV.key?('SENTRY_DSN')

require 'sentry-ruby'
require 'sentry-rails'

Sentry.init do |config|
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.dsn = ENV.fetch('SENTRY_DSN')
  config.enabled_environments = %w[production]
  config.traces_sample_rate = 1.0
end
