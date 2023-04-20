# frozen_string_literal: true

class PipelinesController < ApplicationController
  before_action :require_login
  before_action :ensure_user_is_a_manager_of_organization, only: %i[new edit create update destroy]

  def index
    @pipelines = current_organisation.pipelines.all
  end

  def show
    @pipeline = current_organisation.pipelines.find(params[:id])

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          @pipeline,
          partial: 'pipelines/review_apps',
          locals: { pipeline: @pipeline }
        )
      end
    end
  end

  def new
    @pipeline = current_organisation.pipelines.new
  end

  def edit
    @pipeline = current_organisation.pipelines.find(params[:id])
  end

  def create
    @pipeline = current_organisation.pipelines.new(create_pipeline_params)

    if @pipeline.save
      AddLogdrainJob.perform_async(@pipeline.id)

      redirect_to pipeline_url(@pipeline), notice: 'Pipeline was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @pipeline = current_organisation.pipelines.find(params[:id])

    if @pipeline.update(update_pipeline_params)
      redirect_to pipeline_url(@pipeline), notice: 'Pipeline was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pipeline = current_organisation.pipelines.find(params[:id])
    @pipeline.destroy

    redirect_to pipelines_url, notice: 'Pipeline was successfully destroyed.'
  end

  private

  def create_pipeline_params
    params.require(:pipeline).permit(:uuid, :api_key, :base_size_id, :boost_size_id, :set_env)
  end

  def update_pipeline_params
    create_pipeline_params.slice(:api_key, :base_size_id, :boost_size_id, :set_env)
  end

  def ensure_user_is_a_manager_of_organization
    return if current_user.has_role?(:manager, current_organisation)

    head :forbidden
  end
end
