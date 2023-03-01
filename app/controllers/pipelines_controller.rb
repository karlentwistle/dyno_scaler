class PipelinesController < ApplicationController
  def index
    @pipelines = Pipeline.all
  end

  def show
    @pipeline = Pipeline.find(params[:id])
  end

  def new
    @pipeline = Pipeline.new
  end

  def create
    @pipeline = Pipeline.new(pipeline_params)

    if @pipeline.save
      redirect_to pipeline_url(@pipeline), notice: "Pipeline was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @pipeline = Pipeline.find(params[:id])
    @pipeline.destroy

    redirect_to pipelines_url, notice: "Pipeline was successfully destroyed."
  end

  private

  def pipeline_params
    params.require(:pipeline).permit(:uuid, :api_key)
  end
end
