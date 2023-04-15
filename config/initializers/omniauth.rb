# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.application.config.x.google_oauth[:enabled?]
    provider(
      :google_oauth2,
      Rails.application.config.x.google_oauth[:client_id],
      Rails.application.config.x.google_oauth[:client_secret],
      {
        scope: 'email,profile,userinfo.profile'
      }
    )
  end
end
