# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logs' do
  describe 'POST /logs' do
    it 'requires valid http authentication' do
      post logs_path

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http created' do
      dyno = create(:dyno)

      post_with_basic_auth(logs_path, username: 'username', password: dyno.log_token)

      expect(response).to have_http_status(:created)
    end

    it 'updates associated dynos last_active_at when a request is received' do
      dyno = create(:dyno, last_active_at: nil)

      post_with_basic_auth(logs_path, username: 'username', password: dyno.log_token)

      expect(dyno.reload.last_active_at).to be_within(1.second).of(Time.zone.now)
    end
  end

  private

  def post_with_basic_auth(path, username:, password:)
    encoded_credentials = ActionController::HttpAuthentication::Basic.encode_credentials(
      username,
      password
    )
    headers = { 'HTTP_AUTHORIZATION' => encoded_credentials }

    post(path, headers:)
  end
end
