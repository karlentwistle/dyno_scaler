# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Logs' do
  describe 'POST /logs' do
    it 'requires valid http authentication' do
      post logs_path

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns http created' do
      review_app = create(:review_app)

      post_with_basic_auth(password: review_app.log_token, body: '')

      expect(response).to have_http_status(:created)
    end

    it 'updates associated review_apps last_active_at when a router request is received' do
      review_app = create(:review_app, last_active_at: nil)

      post_with_basic_auth(
        password: review_app.log_token,
        body: Rails.root.join('spec/fixtures/heroku/router').read
      )

      expect(review_app.reload.last_active_at).to be_within(1.second).of(Time.zone.now)
    end

    it 'doesnt update associated review_apps last_active_at when a non-router request is received' do
      review_app = create(:review_app, last_active_at: 1.year.ago)

      expect do
        post_with_basic_auth(
          password: review_app.log_token,
          body: Rails.root.join('spec/fixtures/heroku/web').read
        )

        post_with_basic_auth(
          password: review_app.log_token,
          body: Rails.root.join('spec/fixtures/heroku/runtime_metric').read
        )
      end.not_to(change { review_app.reload.last_active_at })
    end
  end

  private

  def post_with_basic_auth(password:, body:)
    encoded_credentials = ActionController::HttpAuthentication::Basic.encode_credentials(
      'username',
      password
    )
    headers = { 'HTTP_AUTHORIZATION' => encoded_credentials }

    post(logs_path, headers:, params: body)
  end
end
