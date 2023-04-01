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

  describe 'associations' do
    it 'updates associated review apps when base_size is updated' do
      pipeline = create(:pipeline, base_size: DynoSize.eco)
      create_list(:review_app, 3, pipeline:)

      pipeline.update(base_size: DynoSize.standard_1x)

      expect(pipeline.review_apps.pluck(:base_size_id).uniq).to eql([DynoSize.standard_1x.id])
    end

    it 'updates associated review apps when boost_size is updated' do
      pipeline = create(:pipeline, boost_size: DynoSize.basic)
      create_list(:review_app, 3, pipeline:)

      pipeline.update(boost_size: DynoSize.performance_l)

      expect(pipeline.review_apps.pluck(:boost_size_id).uniq).to eql([DynoSize.performance_l.id])
    end
  end
end
