# frozen_string_literal: true

class PipelinesController < ApplicationController
  before_action :require_login

  def index
    @pipelines = current_user.pipelines.all
  end

  def show
    @pipeline = current_user.pipelines.find(params[:id])
    @review_apps = @pipeline.review_apps.recent_first
  end

  def new
    @pipeline = current_user.pipelines.new
  end

  def edit
    @pipeline = current_user.pipelines.find(params[:id])
  end

  def create
    @pipeline = current_user.pipelines.new(create_pipeline_params)

    if @pipeline.save
      AddLogdrainJob.perform_async(@pipeline.id)

      redirect_to pipeline_url(@pipeline), notice: 'Pipeline was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @pipeline = current_user.pipelines.find(params[:id])

    if @pipeline.update(update_pipeline_params)
      redirect_to pipeline_url(@pipeline), notice: 'Pipeline was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pipeline = current_user.pipelines.find(params[:id])
    @pipeline.destroy

    redirect_to pipelines_url, notice: 'Pipeline was successfully destroyed.'
  end

  private

  def create_pipeline_params
    params.require(:pipeline).permit(:uuid, :api_key, :base_size_id, :boost_size_id)
  end

  def update_pipeline_params
    create_pipeline_params.slice(:api_key, :base_size_id, :boost_size_id)
  end
end
