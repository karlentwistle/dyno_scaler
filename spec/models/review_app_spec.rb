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
      review_app = build(
        :review_app,
        base_size: DynoSize.basic,
        boost_size: DynoSize.standard_2x,
        last_active_at: 31.minutes.ago
      )

      expect(review_app.optimal_size).to eq(DynoSize.basic)
    end

    it 'return base_size if dyno has unknown last_active_at' do
      review_app = build(
        :review_app,
        base_size: DynoSize.basic,
        boost_size: DynoSize.standard_2x,
        last_active_at: nil
      )

      expect(review_app.optimal_size).to eq(DynoSize.basic)
    end

    it 'returns boost_size if dyno has been recently active' do
      review_app = build(
        :review_app,
        base_size: DynoSize.basic,
        boost_size: DynoSize.standard_2x,
        last_active_at: 29.minutes.ago
      )

      expect(review_app.optimal_size).to eq(DynoSize.standard_2x)
    end
  end

  describe '#request_received' do
    it 'updates last_active_at' do
      review_app = create(:review_app, last_active_at: nil)

      review_app.request_received

      expect(review_app.last_active_at).to be_within(1.second).of(Time.zone.now)
    end

    it 'enqueues FormationUpdateJob if current dyno isnt the optiomal size' do
      pipeline = create(:pipeline, base_size: DynoSize.basic, boost_size: DynoSize.standard_2x)
      review_app = create(:review_app, pipeline:, current_size: pipeline.base_size, last_active_at: 31.minutes.ago)

      expect { review_app.request_received }.to change(FormationUpdateJob.jobs, :size).by(1)
    end
  end
end
