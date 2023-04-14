# frozen_string_literal: true

module OauthHelper
  def google_auth_enabled?
    Rails.application.config.x.google_oauth[:enabled?]
  end
end
