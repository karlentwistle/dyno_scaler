# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReviewApp do
  describe 'validations' do
    it 'has a valid factory' do
      expect(build(:review_app)).to be_valid
    end

    it 'is invalid without a pipeline' do
      expect(build(:review_app, pipeline: nil)).to be_invalid
    end
  end

  describe '#optimal_size' do
    it 'returns base_size if dyno hasnt been active for 30 minutes' do
      pipeline = build(:pipeline, base_size: DynoSize.basic, boost_size: DynoSize.standard_2x)
      review_app = build(:review_app, pipeline:, last_active_at: 31.minutes.ago)

      expect(review_app.optimal_size).to eq(DynoSize.basic)
    end

    it 'returns boost_size if dyno has been recently active' do
      pipeline = build(:pipeline, base_size: DynoSize.basic, boost_size: DynoSize.standard_2x)
      review_app = build(:review_app, pipeline:, last_active_at: 29.minutes.ago)

      expect(review_app.optimal_size).to eq(DynoSize.standard_2x)
    end
  end
end
