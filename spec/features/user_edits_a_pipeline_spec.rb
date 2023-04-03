# frozen_string_literal: true

require 'rails_helper'

describe 'User edits a pipeline' do
  it 'persists the changes and display a flash success banner' do
    pipeline = create(
      :pipeline,
      name: 'My Pipeline',
      base_size: DynoSize.eco,
      boost_size: DynoSize.basic,
      set_env: true
    )

    visit pipeline_path(pipeline, as: pipeline.user)
    click_on 'Edit'

    select 'Basic', from: 'Base dyno type'
    select 'Standard-1X', from: 'Boost dyno type'
    uncheck 'Set env variable'

    click_on 'Update Pipeline'
    expect(page).to have_text 'Pipeline was successfully updated'

    click_on 'Edit'
    expect(page).to have_select('Base dyno type', selected: 'Basic')
    expect(page).to have_select('Boost dyno type', selected: 'Standard-1X')
    expect(page).to have_unchecked_field('Set env variable')
  end

  it 'disables editing of the uuid' do
    pipeline = create(:pipeline, name: 'My Pipeline', base_size: DynoSize.eco, boost_size: DynoSize.basic)

    visit edit_pipeline_path(pipeline, as: pipeline.user)

    expect(page).to have_field('UUID', disabled: true)
  end
end
