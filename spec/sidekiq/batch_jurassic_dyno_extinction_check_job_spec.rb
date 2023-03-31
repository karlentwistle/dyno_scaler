# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BatchJurassicDynoExtinctionCheckJob, type: :job do
  describe '#perform' do
    it 'enqueues JurassicDynoExtinctionCheckJob for review apps that are potentially extinct' do
      potentially_extinct_a = create(:review_app, last_active_at: 6.hours.ago - 1.minute)
      potentially_extinct_b = create(:review_app, last_active_at: 10.days.ago)
      _not_potentially_extinct_a = create(:review_app, last_active_at: 1.second.ago)
      _not_potentially_extinct_b = create(:review_app, last_active_at: 1.hour.ago)

      described_class.new.perform

      expect(JurassicDynoExtinctionCheckJob.jobs.pluck('args')).to contain_exactly(
        [potentially_extinct_a.id],
        [potentially_extinct_b.id]
      )
    end
  end
end
