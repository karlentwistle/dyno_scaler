# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PipelinesController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/pipelines').to route_to('pipelines#index')
    end

    it 'routes to #new' do
      expect(get: '/pipelines/new').to route_to('pipelines#new')
    end

    it 'routes to #show' do
      expect(get: '/pipelines/1').to route_to('pipelines#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/pipelines').to route_to('pipelines#create')
    end

    it 'routes to #destroy' do
      expect(delete: '/pipelines/1').to route_to('pipelines#destroy', id: '1')
    end
  end
end
