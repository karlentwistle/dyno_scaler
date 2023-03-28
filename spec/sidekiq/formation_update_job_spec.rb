# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormationUpdateJob, type: :job do
  it 'ignores dyno which doesnt exist' do
    subject = described_class.new

    expect { subject.perform(1) }.not_to raise_error
  end

  it 'doesnt send a request if the dyno is already the optimal size' do
    pipeline = create(:pipeline, api_key: 'pipeline_api_key')
    review_app = create(
      :review_app,
      pipeline:,
      app_id: 'app_id',
      last_active_at: 1.second.ago,
      current_size: pipeline.boost_size
    )

    upscale_dyno_request = stub_formation_update('app_id', 1, pipeline.boost_size.name)

    described_class.new.perform(review_app.id)

    expect(upscale_dyno_request).not_to have_been_requested
  end

  it 'downscales a web dyno if it hasnt been active for 30 minutes' do
    pipeline = create(
      :pipeline,
      boost_size: DynoSize.performance_l,
      base_size: DynoSize.performance_m,
      api_key: 'pipeline_api_key'
    )
    review_app = create(:review_app, pipeline:, app_id: 'app_id', last_active_at: 31.minutes.ago)

    downscale_dyno_request = stub_formation_update('app_id', 1, DynoSize.performance_m.name)

    described_class.new.perform(review_app.id)

    expect(downscale_dyno_request).to have_been_requested.once
    expect(review_app.reload.current_size).to eq(DynoSize.performance_m)
  end

  it 'upscales a web dyno if its been recently active' do
    pipeline = create(
      :pipeline,
      boost_size: DynoSize.performance_l,
      base_size: DynoSize.performance_m,
      api_key: 'pipeline_api_key'
    )
    review_app = create(:review_app, pipeline:, app_id: 'app_id', last_active_at: 2.minutes.ago)

    upscale_dyno_request = stub_formation_update('app_id', 1, DynoSize.performance_l.name)

    described_class.new.perform(review_app.id)

    expect(upscale_dyno_request).to have_been_requested.once
    expect(review_app.reload.current_size).to eq(DynoSize.performance_l)
  end

  it 'destroys the review app if Heroku responds with a 404' do
    pipeline = create(:pipeline, api_key: 'pipeline_api_key')
    review_app = create(:review_app, pipeline:, app_id: 'app_id')

    stub_request(:patch, 'https://api.heroku.com/apps/app_id/formation/web').to_return(status: 404)

    described_class.new.perform(review_app.id)

    expect { review_app.reload }.to raise_error(ActiveRecord::RecordNotFound)
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
      .to_return(
        status: 200,
        body: {
          app: {
            name: 'example',
            id: '01234567-89ab-cdef-0123-456789abcdef'
          },
          command: 'bundle exec rails server -p $PORT',
          created_at: '2012-01-01T12:00:00Z',
          id: '01234567-89ab-cdef-0123-456789abcdef',
          quantity:,
          size:,
          type: 'web',
          updated_at: '2012-01-01T12:00:00Z'
        }.to_json,
        headers: { 'Content-Type' => 'application/json;charset=utf-8' }
      )
  end
end
