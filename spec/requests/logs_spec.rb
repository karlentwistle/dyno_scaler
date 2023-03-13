# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logs' do
  describe 'POST /logs' do
    it 'requires valid http authentication' do
      post logs_path

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http created' do
      post_with_basic_auth(logs_path, username: 'username', password: 'password')

      expect(response).to have_http_status(:created)
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
