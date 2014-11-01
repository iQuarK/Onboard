class JobsController < ApplicationController

  before_action :authenticate_user!, only: [:manage]
  before_action :set_company
  before_action :set_job, only: [:show, :edit, :update, :destroy, :manage]

  # -------------------------------------------------------------------------------------------------------------------
  # GET /companies/:company_id/jobs
  # -------------------------------------------------------------------------------------------------------------------
  def index
    @jobs = @company.jobs.all
  end

  # -------------------------------------------------------------------------------------------------------------------
  # GET /jobs/1
  # -------------------------------------------------------------------------------------------------------------------
  def show
  end

  # -------------------------------------------------------------------------------------------------------------------
  # GET /companies/:company_id/jobs/new
  # -------------------------------------------------------------------------------------------------------------------
  def new
    @job = @company.jobs.new
  end

  # -------------------------------------------------------------------------------------------------------------------
  # GET /jobs/1/edit
  # -------------------------------------------------------------------------------------------------------------------
  def edit
  end

  # -------------------------------------------------------------------------------------------------------------------
  # POST /companies/:company_id/jobs
  # -------------------------------------------------------------------------------------------------------------------
  def create
    @job = @company.jobs.new(job_params)

    if @job.save
      redirect_to [@company, @job], notice: 'Job was successfully created.'
    else
      render :new
    end
  end

  # -------------------------------------------------------------------------------------------------------------------
  # PATCH/PUT /jobs/1
  # -------------------------------------------------------------------------------------------------------------------
  def update
    if @job.update(job_params)
      redirect_to [@company, @job], notice: 'Job was successfully updated.'
    else
      render :edit
    end
  end

  # -------------------------------------------------------------------------------------------------------------------
  # DELETE /jobs/1
  # -------------------------------------------------------------------------------------------------------------------
  def destroy
    @job.destroy
    redirect_to company_jobs_path(@company), notice: 'Job was successfully destroyed.'
  end

  # -------------------------------------------------------------------------------------------------------------------
  # GET /jobs/:id/manage
  # -------------------------------------------------------------------------------------------------------------------
  def manage

  end

  # -------------------------------------------------------------------------------------------------------------------
  # Private
  # -------------------------------------------------------------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = @company.jobs.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_params
    params.require(:job).permit(:title, :description, :location, :remote, :industry, :job_type)
  end

  def set_company
    @company = Company.find(params[:company_id])
  end

end
