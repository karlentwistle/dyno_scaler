# frozen_string_literal: true

require 'rails_helper'

describe 'User creates a pipeline' do
  it 'display a flash success banner' do
    visit new_pipeline_path(as: create(:user))

    create_pipeline(name: 'My Pipeline')

    expect(page).to have_text 'Pipeline was successfully created'
    expect(page).to have_text 'My Pipeline'

    # TODO: - refactor this to click on pipeline edit form and assert the values are set
    expect(Pipeline.last).to have_attributes(
      base_size_id: 2,
      boost_size_id: 3
    )
  end

  it 'enqueue a job to attach the log drain to each review app' do
    visit new_pipeline_path(as: create(:user))

    expect { create_pipeline }.to change(AddLogdrainJob.jobs, :size).from(0).to(1)
  end

  it 'display an error if the UUID is invalid' do
    stub_request(:get, 'https://api.heroku.com/pipelines/invalid-uuid').to_return(status: 404)

    visit new_pipeline_path(as: create(:user))
    fill_in 'UUID', with: 'invalid-uuid'
    click_button 'Create Pipeline'

    expect(page).to have_text 'Uuid is invalid'
  end

  it 'display an error if the API key is invalid' do
    stub_request(:get, 'https://api.heroku.com/pipelines/462c0eac-7680-4682-bf01-f1748d5f6919').to_return(status: 401)

    visit new_pipeline_path(as: create(:user))
    fill_in 'API key', with: 'invalid-api-key'
    fill_in 'UUID', with: '462c0eac-7680-4682-bf01-f1748d5f6919'
    click_button 'Create Pipeline'

    expect(page).to have_text 'Api key is invalid'
  end

  private

  def create_pipeline(name: Faker::App.name)
    uuid = '462c0eac-7680-4682-bf01-f1748d5f6919'
    api_key = '75ed542b-271b-44be-99c4-3f282e3f3d8d'

    stub_pipeline_info(uuid:, api_key:, name:)

    fill_in 'UUID', with: uuid
    fill_in 'API key', with: '75ed542b-271b-44be-99c4-3f282e3f3d8d'
    select 'Basic', from: 'Base dyno type'
    select 'Standard-1X', from: 'Boost dyno type'

    click_button 'Create Pipeline'
  end

  def stub_pipeline_info(uuid:, api_key:, name:)
    stub_request(:get, "https://api.heroku.com/pipelines/#{uuid}")
      .with(
        headers: {
          'Accept' => 'application/vnd.heroku+json; version=3',
          'Authorization' => "Bearer #{api_key}"
        }
      )
      .to_return(
        status: 200,
        body: {
          created_at: '2012-01-01T12:00:00Z',
          id: Faker::Internet.uuid,
          name:,
          owner: {
            id: Faker::Internet.uuid,
            type: 'team'
          },
          updated_at: '2012-01-01T12:00:00Z'
        }.to_json,
        headers: { 'Content-Type' => 'application/json;charset=utf-8' }
      )
  end
end
