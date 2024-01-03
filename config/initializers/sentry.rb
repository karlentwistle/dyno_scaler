# frozen_string_literal: true

return unless ENV.key?('SENTRY_DSN')

Sentry.init do |config|
  config.breadcrumbs_logger = %i[active_support_logger http_logger]
  config.dsn = ENV.fetch('SENTRY_DSN')
  config.enabled_environments = %w[production]
  config.excluded_exceptions += [
    'Errors::RetryWithoutReporting'
  ]
end
