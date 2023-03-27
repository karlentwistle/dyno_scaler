# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormationUpdateJob, type: :job do
  it 'ignores dyno which doesnt exist' do
    subject = described_class.new

    expect { subject.perform(1) }.not_to raise_error
  end

  it 'downscales a web dyno if it hasnt been active for 30 minutes' do
    pipeline = create(
      :pipeline,
      boost_size: DynoSize.performance_l,
      base_size: DynoSize.performance_m,
      api_key: 'pipeline_api_key'
    )
    review_app = create(:review_app, pipeline:, app_id: 'app_id', last_active_at: 31.minutes.ago)

    downscale_dyno_request = stub_formation_update('app_id', 1, DynoSize.performance_m.code)

    described_class.new.perform(review_app.id)

    expect(downscale_dyno_request).to have_been_requested.once
  end

  it 'upscales a web dyno if its been recently active' do
    pipeline = create(
      :pipeline,
      boost_size: DynoSize.performance_l,
      base_size: DynoSize.performance_m,
      api_key: 'pipeline_api_key'
    )
    review_app = create(:review_app, pipeline:, app_id: 'app_id', last_active_at: 2.minutes.ago)

    upscale_dyno_request = stub_formation_update('app_id', 1, DynoSize.performance_l.code)

    described_class.new.perform(review_app.id)

    expect(upscale_dyno_request).to have_been_requested.once
  end

  private

  def stub_formation_update(app_id, quantity, size)
    stub_request(:patch, "https://api.heroku.com/apps/#{app_id}/formation/web")
      .with(
        body: { quantity:, size: }.to_json,
        headers: {
          'Authorization' => 'Bearer pipeline_api_key'
        }
      )
      .to_return(status: 200, body: '', headers: {})
  end
end
