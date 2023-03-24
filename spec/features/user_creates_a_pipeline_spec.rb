# frozen_string_literal: true

require 'rails_helper'

describe 'User creates a pipeline' do
  it 'they see a successful flash banner' do
    visit new_pipeline_path(as: create(:user))

    fill_in 'UUID', with: '462c0eac-7680-4682-bf01-f1748d5f6919'
    fill_in 'API key', with: '75ed542b-271b-44be-99c4-3f282e3f3d8d'
    select 'Basic', from: 'Base dyno type'
    select 'Standard-1X', from: 'Boost dyno type'

    click_button 'Create Pipeline'

    expect(page).to have_text 'Pipeline was successfully created'

    # TODO: - refactor this to click on pipeline edit form and assert the values are set
    expect(Pipeline.last).to have_attributes(
      base_size_id: 2,
      boost_size_id: 3
    )
  end
end
