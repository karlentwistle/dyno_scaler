# frozen_string_literal: true

require 'rails_helper'

describe 'User views pipeline' do
  it 'they see their pipelines' do
    owner, another_user = create_list(:user, 2)
    create(:pipeline, user: owner, uuid: 'c961ec04-c764-11ed-afa1-0242ac120002')
    create(:pipeline, user: another_user, uuid: 'dde075f6-c764-11ed-afa1-0242ac120002')

    visit pipelines_path(as: owner)

    expect(page).to have_text 'c961ec04-c764-11ed-afa1-0242ac120002'
    expect(page).not_to have_text 'dde075f6-c764-11ed-afa1-0242ac120002'
  end

  it 'shows a list of dynos associated with the pipeline' do
    owner = create(:user)
    pipeline = create(:pipeline, user: owner)
    create(:dyno, pipeline:, app_id: '68ff91da-c7c4-11ed-afa1-0242ac120002')
    create(:dyno, pipeline:, app_id: '6c61b592-c7c4-11ed-afa1-0242ac120002')
    create(:dyno, pipeline:, app_id: '6ebccc5a-c7c4-11ed-afa1-0242ac120002')

    visit pipeline_path(pipeline, as: owner)

    expect(page).to have_text('68ff91da-c7c4-11ed-afa1-0242ac120002')
    expect(page).to have_text('6c61b592-c7c4-11ed-afa1-0242ac120002')
    expect(page).to have_text('6ebccc5a-c7c4-11ed-afa1-0242ac120002')
  end
end
