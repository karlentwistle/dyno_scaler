# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddLogdrainJob, type: :job do
  it 'ignores pipelines which doesnt exist' do
    subject = described_class.new

    expect { subject.perform(1) }.not_to raise_error
  end

  it 'attaches drain to pipelines dynos' do
    pipeline = create(:pipeline, uuid: 'pipeline_uuid', api_key: 'pipeline_api_key')

    stub_pipeline_response
    stub_empty_log_drains_list('b756ff11-cca0-4079-a26f-ddc4c58ffd2b')
    stub_empty_log_drains_list('a11a232d-5606-4eeb-956f-bbbf63977380')
    log_drain_create_a = stub_log_drain_create('b756ff11-cca0-4079-a26f-ddc4c58ffd2b')
    log_drain_create_b = stub_log_drain_create('a11a232d-5606-4eeb-956f-bbbf63977380')

    described_class.new.perform(pipeline.id)

    expect(log_drain_create_a).to have_been_requested.once
    expect(log_drain_create_b).to have_been_requested.once
  end

  it 'doesnt attach drain to a review_app thats already attached' do
    pipeline = create(:pipeline, uuid: 'pipeline_uuid', api_key: 'pipeline_api_key')
    review_app_a = create(:review_app, pipeline:, app_id: 'b756ff11-cca0-4079-a26f-ddc4c58ffd2b')
    review_app_b = create(:review_app, pipeline:, app_id: 'a11a232d-5606-4eeb-956f-bbbf63977380')

    stub_pipeline_response
    stub_log_drains_list('b756ff11-cca0-4079-a26f-ddc4c58ffd2b', review_app_a.logs_url)
    stub_log_drains_list('a11a232d-5606-4eeb-956f-bbbf63977380', review_app_b.logs_url)

    described_class.new.perform(pipeline.id)

    expect(a_request(:post, 'https://api.heroku.com/apps/[^/]+/log-drains')).not_to have_been_made
  end

  def stub_pipeline_response
    stub_request(:get, 'https://api.heroku.com/pipelines/pipeline_uuid/review-apps')
      .with(
        headers: { 'Authorization' => 'Bearer pipeline_api_key' }
      )
      .to_return(
        status: 200,
        body: Rails.root.join('spec/fixtures/heroku/review_apps.json').read,
        headers: { 'Content-Type' => 'application/json;charset=utf-8' }
      )
  end

  def stub_empty_log_drains_list(app_id)
    stub_request(:get, "https://api.heroku.com/apps/#{app_id}/log-drains")
      .with(
        headers: { 'Authorization' => 'Bearer pipeline_api_key' }
      )
      .to_return(
        status: 200,
        body: [].to_json,
        headers: { 'Content-Type' => 'application/json;charset=utf-8' }
      )
  end

  def stub_log_drains_list(app_id, url)
    stub_request(:get, "https://api.heroku.com/apps/#{app_id}/log-drains")
      .with(
        headers: { 'Authorization' => 'Bearer pipeline_api_key' }
      )
      .to_return(
        status: 200,
        body: [
          {
            'addon' => nil,
            'created_at' => '2023-03-17T21:53:07Z',
            'id' => '24e90825-ad31-4bb1-b938-e52bead6084a',
            'token' => 'd.bd0d138c-3136-4494-83b1-df0c1a5b0fea',
            'updated_at' => '2023-03-17T21:53:08Z',
            'url' => url
          }
        ].to_json,
        headers: { 'Content-Type' => 'application/json;charset=utf-8' }
      )
  end

  def stub_log_drain_create(app_id)
    hostname = Rails.configuration.x.log_drain.hostname

    stub_request(:post, "https://api.heroku.com/apps/#{app_id}/log-drains")
      .with(
        body: %r{{"url":"https://username:[a-zA-Z0-9]{24}+@#{hostname}/logs"}},
        headers: {
          'Authorization' => 'Bearer pipeline_api_key'
        }
      )
      .to_return(status: 201)
  end
end
