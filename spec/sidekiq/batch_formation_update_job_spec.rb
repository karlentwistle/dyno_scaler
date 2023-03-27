# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BatchFormationUpdateJob, type: :job do
  describe '#perform' do
    it 'enqueues FormationUpdateJob for all review app ids' do
      create(:review_app, id: 1)
      create(:review_app, id: 2)

      described_class.new.perform

      expect(FormationUpdateJob.jobs.pluck('args')).to match_array([[1], [2]])
    end
  end
end
