# frozen_string_literal: true

require 'rails_helper'

describe 'User views pipeline' do
  it 'shows only their pipelines' do
    owner, another_user = create_list(:user, 2)
    create(:pipeline, user: owner, uuid: 'c961ec04-c764-11ed-afa1-0242ac120002')
    create(:pipeline, user: another_user, uuid: 'dde075f6-c764-11ed-afa1-0242ac120002')

    visit pipelines_path(as: owner)

    expect(page).to have_text 'c961ec04-c764-11ed-afa1-0242ac120002'
    expect(page).not_to have_text 'dde075f6-c764-11ed-afa1-0242ac120002'
  end

  it 'shows a list of dynos associated with the pipeline ordered by last_active_at' do
    owner = create(:user)
    pipeline = create(:pipeline, user: owner)
    create(:dyno, pipeline:, app_id: 'Charlie', last_active_at: 1.year.ago)
    create(:dyno, pipeline:, app_id: 'Bravo', last_active_at: 1.week.ago)
    create(:dyno, pipeline:, app_id: 'Alpha', last_active_at: 1.day.ago)

    visit pipeline_path(pipeline, as: owner)

    expect(page).to have_content(/Alpha.*Bravo.*Charlie/)
  end

  it 'allows the user to destroy the pipeline' do
    owner = create(:user)
    pipeline = create(:pipeline, user: owner, uuid: 'c961ec04-c764-11ed-afa1-0242ac120002')

    visit pipeline_path(pipeline, as: owner)
    click_on 'Destroy this pipeline'

    expect(page).to have_content('Pipeline was successfully destroyed.')
    expect(page).not_to have_text 'dde075f6-c764-11ed-afa1-0242ac120002'
  end
end
