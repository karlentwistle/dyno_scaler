# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Visitor signs up via oauth' do
  it 'authenticates a user with valid google oauth' do
    create(:organisation, hosted_domain: 'example.org')
    mock_valid_google_oauth(hd: 'example.org', email: 'bob@example.org')

    visit sign_in_path
    click_button 'Sign in with Google'

    expect_user_to_be_signed_in
  end

  it 'returns error 404 if organisation doesnt exist' do
    mock_valid_google_oauth(hd: 'example.org', email: 'bob@example.org')

    visit sign_in_path

    expect { click_button 'Sign in with Google' }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns error 404 if hosted domain is unavailable in oauth hash' do
    create(:organisation, hosted_domain: 'gmail.com')
    mock_valid_google_oauth(hd: nil, email: 'karl@gmail.com')

    visit sign_in_path

    expect { click_button 'Sign in with Google' }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns error 404 if email is unavailable in oauth hash' do
    create(:organisation, hosted_domain: 'example.org')
    mock_valid_google_oauth(hd: 'example.org', email: '')

    visit sign_in_path

    expect { click_button 'Sign in with Google' }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
