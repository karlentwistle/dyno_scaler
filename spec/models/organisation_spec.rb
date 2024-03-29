# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organisation do
  it 'has a valid factory' do
    expect(build(:organisation)).to be_valid
  end
end
