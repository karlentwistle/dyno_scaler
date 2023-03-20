# frozen_string_literal: true

require 'rails_helper'

describe 'User creates a pipeline' do
  it 'they see a successful flash banner' do
    visit new_pipeline_path(as: create(:user))

    fill_in 'UUID', with: '462c0eac-7680-4682-bf01-f1748d5f6919'
    fill_in 'API Key', with: '75ed542b-271b-44be-99c4-3f282e3f3d8d'
    click_button 'Create Pipeline'

    expect(page).to have_text 'Pipeline was successfully created'
  end
end
