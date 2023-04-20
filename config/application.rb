# frozen_string_literal: true

require_relative 'boot'

require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'action_cable/engine'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dynoscaler
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.x.log_drain.hostname = ENV.fetch('LOG_DRAIN_HOSTNAME')

    config.x.google_oauth = {
      enabled?: ENV['GOOGLE_CLIENT_ID'].present? && ENV['GOOGLE_CLIENT_SECRET'].present?,
      client_id: ENV.fetch('GOOGLE_CLIENT_ID', nil),
      client_secret: ENV.fetch('GOOGLE_CLIENT_SECRET', nil)
    }

    config.x.polling_interval_seconds = ENV.fetch('POLLING_INTERVAL_SECONDS', 10).to_i
  end
end
