# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pipeline do
  describe 'validations' do
    it 'has a valid factory' do
      expect(build(:pipeline)).to be_valid
    end

    it 'is invalid without a uuid' do
      expect(build(:pipeline, uuid: nil)).to be_invalid
    end

    it 'is invalid without a api_key' do
      expect(build(:pipeline, api_key: nil)).to be_invalid
    end

    it 'is invalid when largest dyno size is placed in base_size' do
      expect(build(:pipeline, base_size: DynoSize.largest)).to be_invalid
    end

    it 'is invalid when smallest dyno size is placed in boost_size' do
      expect(build(:pipeline, boost_size: DynoSize.smallest)).to be_invalid
    end
  end
end
