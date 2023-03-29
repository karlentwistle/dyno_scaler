# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BatchAddLogdrainJob, type: :job do
  describe '#perform' do
    it 'enqueues AddLogdrainJob for all pipeline ids' do
      create(:pipeline, id: 1)
      create(:pipeline, id: 2)

      described_class.new.perform

      expect(AddLogdrainJob.jobs.pluck('args')).to contain_exactly([1], [2])
    end
  end
end
