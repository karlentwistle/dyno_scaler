# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BatchFormationUpdateJob, type: :job do
  describe '#perform' do
    it 'enqueues FormationUpdateJob for review apps awaiting update' do
      pipeline = create(:pipeline, boost_size: DynoSize.performance_l, base_size: DynoSize.performance_m)

      awaiting_update_a = create(
        :review_app,
        pipeline:,
        current_size: nil,
        last_active_at: nil
      )
      awaiting_update_b = create(
        :review_app,
        pipeline:,
        current_size: pipeline.base_size,
        last_active_at: 1.minute.ago
      )
      awaiting_update_c = create(
        :review_app,
        pipeline:,
        current_size: pipeline.boost_size,
        last_active_at: 31.minutes.ago
      )
      _not_awaiting_update_a = create(
        :review_app,
        pipeline:,
        current_size: pipeline.boost_size,
        last_active_at: 1.second.ago
      )
      _not_awaiting_update_b = create(
        :review_app,
        pipeline:,
        current_size: pipeline.base_size,
        last_active_at: 1.hour.ago
      )

      described_class.new.perform

      expect(FormationUpdateJob.jobs.pluck('args')).to contain_exactly(
        [awaiting_update_a.id],
        [awaiting_update_b.id],
        [awaiting_update_c.id]
      )
    end
  end
end
