# frozen_string_literal: true

require 'rails_helper'

describe 'User views pipeline' do
  it 'shows only their organisations pipelines' do
    owned_pipeline = create(:pipeline, uuid: 'c961ec04-c764-11ed-afa1-0242ac120002')
    _another_pipeline = create(:pipeline, uuid: 'dde075f6-c764-11ed-afa1-0242ac120002')
    user = create(:user, organisation: owned_pipeline.organisation)

    visit pipelines_path(as: user)

    expect(page).to have_text 'c961ec04-c764-11ed-afa1-0242ac120002'
    expect(page).not_to have_text 'dde075f6-c764-11ed-afa1-0242ac120002'
  end

  it 'shows a list of review apps associated with the pipeline ordered by last_active_at' do
    pipeline = create(:pipeline)
    user = create(:user, organisation: pipeline.organisation)
    create(:review_app, pipeline:, branch: 'Delta', last_active_at: 1.year.ago)
    create(:review_app, pipeline:, branch: 'Charlie', last_active_at: 1.week.ago)
    create(:review_app, pipeline:, branch: 'Bravo', last_active_at: 1.day.ago)
    create(:review_app, pipeline:, branch: 'Alpha', last_active_at: nil)

    visit pipeline_path(pipeline, as: user)

    expect(page).to have_content(/Alpha.*Bravo.*Charlie.*Delta/)
  end
end
