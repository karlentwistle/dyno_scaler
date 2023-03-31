# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JurassicDynoExtinctionCheckJob, type: :job do
  it 'deletes dynos that have gone extinct' do
    review_app = create(:review_app, last_active_at: 6.hours.ago - 1.minute)
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

  private

  def stub_review_app_request(app_id, status)
    stub_request(:get, "https://api.heroku.com/apps/#{app_id}/review-app")
      .to_return(status:)
  end
end
