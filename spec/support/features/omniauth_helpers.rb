# frozen_string_literal: true

module Features
  module OmniauthHelpers
    def mock_valid_google_oauth(email: 'bob@example.org', hd: 'example.org') # rubocop:disable Naming/MethodParameterName
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        {
          info: {
            email:
          },
          extra: {
            raw_info: {
              hd:
            }
          }
        }
      )
    end
  end
end

RSpec.configure do |config|
  config.include Features::OmniauthHelpers, type: :feature
end
