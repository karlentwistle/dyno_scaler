# frozen_string_literal: true

require 'rails_helper'

describe 'Manager destroy a pipeline' do
  it 'allows the user to destroy the pipeline' do
    pipeline = create(:pipeline, uuid: 'c961ec04-c764-11ed-afa1-0242ac120002')
    user = create(:user, :manager, organisation: pipeline.organisation)

    visit pipeline_path(pipeline, as: user)
    click_on 'Destroy this pipeline'

    expect(page).to have_content('Pipeline was successfully destroyed.')
    expect(page).to have_no_text 'dde075f6-c764-11ed-afa1-0242ac120002'
  end
end
