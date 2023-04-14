# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Visitor signs up via oauth' do
  it 'authenticates a user with valid google oauth' do
    organisation = create(:organisation, hosted_domain: 'example.org')
    create(:user, email: 'bob@example.org', organisation:)
    mock_valid_google_oauth(hd: 'example.org', email: 'bob@example.org')

    visit sign_in_path
    click_button 'Login with Google'

    expect_user_to_be_signed_in
  end
end
