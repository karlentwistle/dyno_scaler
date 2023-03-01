# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pipeline do
  describe 'validations' do
    it 'has a fail factory' do
      expect(build(:pipeline)).to be_valid
    end

    it 'is invalid without a uuid' do
      expect(build(:pipeline, uuid: nil)).to be_invalid
    end

    it 'is invalid without a api_key' do
      expect(build(:pipeline, api_key: nil)).to be_invalid
    end
  end
end
