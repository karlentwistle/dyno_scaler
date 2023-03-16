# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddLogdrainToPipelineDynosJob, type: :job do
  it 'ignores pipelines which doesnt exist' do
    subject = described_class.new

    expect { subject.perform(1) }.not_to raise_error
  end

  it 'attaches drain to pipelines dynos' do
    stub_pipeline_response
    stub_empty_log_drains_list('b756ff11-cca0-4079-a26f-ddc4c58ffd2b')
    stub_empty_log_drains_list('a11a232d-5606-4eeb-956f-bbbf63977380')
    log_drain_create = stub_log_drain_create
    pipeline = create(:pipeline, uuid: 'pipeline_uuid', api_key: 'pipeline_api_key')

    described_class.new.perform(pipeline.id)

    expect(log_drain_create).to have_been_requested.times(2)
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

  def stub_log_drain_create
    stub_request(:post, %r{https://api.heroku.com/apps/%7B:url=%3E%22https://username:[a-zA-Z0-9]{24}@localhost:3000/logs%22%7D/log-drains})
      .to_return(status: 201)
  end
end
