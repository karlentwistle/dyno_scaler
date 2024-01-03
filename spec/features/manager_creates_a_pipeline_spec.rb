# frozen_string_literal: true

require 'rails_helper'

describe 'Manager creates a pipeline' do
  it 'persists the changes and display a flash success banner' do
    visit new_pipeline_path(as: create(:user, :manager))

    create_pipeline(name: 'My Pipeline')

    expect(page).to have_text 'Pipeline was successfully created'
    expect(page).to have_text 'My Pipeline'

    click_link 'Edit'
    expect(page).to have_select('Base dyno type', selected: 'Basic')
    expect(page).to have_select('Boost dyno type', selected: 'Standard-1X')
    expect(page).to have_checked_field('Set env variable')
  end

  it 'enqueue a job to attach the log drain to each review app' do
    visit new_pipeline_path(as: create(:user, :manager))

    expect { create_pipeline }.to change(AddLogdrainJob.jobs, :size).from(0).to(1)
  end

  it 'display an error if the UUID is invalid' do
    stub_request(:get, 'https://api.heroku.com/pipelines/invalid-uuid').to_return(status: 404)

    visit new_pipeline_path(as: create(:user, :manager))
    fill_in 'API key', with: '75ed542b-271b-44be-99c4-3f282e3f3d8d'
    fill_in 'UUID', with: 'invalid-uuid'
    click_button 'Create Pipeline'

    expect(page).to have_text 'Uuid is invalid'
  end

  it 'display an error if the API key is invalid' do
    stub_request(:get, 'https://api.heroku.com/pipelines/462c0eac-7680-4682-bf01-f1748d5f6919').to_return(status: 401)

    visit new_pipeline_path(as: create(:user, :manager))
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
    check 'Set env variable'

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
