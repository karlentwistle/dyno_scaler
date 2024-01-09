# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Visitor signs up' do
  it 'by navigating to the page' do
    visit sign_in_path

    click_on I18n.t('sessions.form.sign_up')

    expect(page).to have_current_path sign_up_path, ignore_query: true
  end

  it 'with valid email, password and organisation name' do
    sign_up_with 'valid@example.com', 'password', 'My Organisation'

    expect_user_to_be_signed_in
  end

  it 'tries with invalid email' do
    sign_up_with 'invalid_email', 'password', 'My Organisation'

    expect_user_to_be_signed_out
  end

  it 'tries with blank password' do
    sign_up_with 'valid@example.com', '', 'My Organisation'

    expect_user_to_be_signed_out
  end

  it 'tries with blank organisation name' do
    sign_up_with 'valid@example.com', 'password', ''

    expect_user_to_be_signed_out
  end
end
