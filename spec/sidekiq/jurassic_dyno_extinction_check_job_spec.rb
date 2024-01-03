# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JurassicDynoExtinctionCheckJob, type: :job do
  it 'deletes dynos that have gone extinct' do
    review_app = create(:review_app, :potentially_extinct)
    stub_review_app_request(review_app.app_id, 403)

    described_class.perform_inline(review_app.id)

    expect { review_app.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'does not delete dynos that have not gone extinct' do
    review_app = create(:review_app, last_active_at: 5.hours.ago - 59.minutes)
    stub_review_app_request(review_app.app_id, 200)

    described_class.perform_inline(review_app.id)

    expect { review_app.reload }.not_to raise_error
  end

  it 'retries on timeout without reporting the error' do
    review_app = create(:review_app, :potentially_extinct)
    stub_review_app_request_timeout(review_app.app_id)

    expect do
      described_class.perform_inline(review_app.id)
    end.to raise_error(Errors::RetryWithoutReporting)
  end

  private

  def stub_review_app_request(app_id, status)
    stub_request(:get, "https://api.heroku.com/apps/#{app_id}/review-app")
      .to_return(status:)
  end

  def stub_review_app_request_timeout(app_id)
    stub_request(:get, "https://api.heroku.com/apps/#{app_id}/review-app")
      .to_timeout
  end
end
