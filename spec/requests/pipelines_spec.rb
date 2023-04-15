# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pipelines' do
  let(:pipeline) { create(:pipeline) }
  let(:manager) { create(:user, :manager, organisation: pipeline.organisation) }
  let(:viewer) { create(:user, :viewer, organisation: pipeline.organisation) }

  describe 'GET /pipelines' do
    it 'returns HTTP OK for viewer and manager' do
      [viewer, manager].each do |user|
        get pipelines_path(as: user)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /pipelines/:id' do
    it 'returns HTTP OK for viewer and manager' do
      [viewer, manager].each do |user|
        get pipeline_path(pipeline, as: user)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /pipelines/new' do
    it 'returns HTTP OK for manager' do
      get new_pipeline_path(as: manager)
      expect(response).to have_http_status(:ok)
    end

    it 'returns HTTP Forbidden for viewer' do
      get new_pipeline_path(as: viewer)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'GET /pipelines/:id/edit' do
    it 'returns HTTP OK for manager' do
      get edit_pipeline_path(pipeline, as: manager)
      expect(response).to have_http_status(:ok)
    end

    it 'returns HTTP Forbidden for viewer' do
      get edit_pipeline_path(pipeline, as: viewer)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /pipelines' do
    it 'returns HTTP Unprocessable Entity for manager' do
      post pipelines_path(as: manager, params: { pipeline: { name: 'test' } })
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns HTTP Forbidden for viewer' do
      post pipelines_path(as: viewer, params: { pipeline: { name: 'test' } })
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PATCH /pipelines' do
    it 'updates the pipeline and returns HTTP redirect for manager' do
      patch pipeline_path(pipeline, as: manager, params: { pipeline: { name: 'test' } })
      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response.body).to include('Pipeline was successfully updated.')
    end

    it 'returns HTTP Forbidden for viewer' do
      patch pipeline_path(pipeline, as: viewer, params: { pipeline: { name: 'test' } })
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /pipelines/:id' do
    it 'destroys the pipeline and returns HTTP redirect for manager' do
      delete pipeline_path(pipeline, as: manager)
      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response.body).to include('Pipeline was successfully destroyed.')
    end

    it 'returns HTTP Forbidden for viewer' do
      delete pipeline_path(pipeline, as: viewer)
      expect(response).to have_http_status(:forbidden)
    end
  end
end
