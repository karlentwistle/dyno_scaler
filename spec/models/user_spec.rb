# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it 'assigns a default role to user' do
    organisation = create(:organisation)
    user = create(:user, organisation:)

    expect(user.has_role?(:viewer, organisation)).to be true
  end
end
