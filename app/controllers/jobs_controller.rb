class JobsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_company
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr/jobs
  # -------------------------------------------------------------------------------------------------------------------
  def index
    @jobs = @company.jobs.all
    render layout: 'external'
  end

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr/jobs/1
  # -------------------------------------------------------------------------------------------------------------------
  def show
    render layout: 'external'
  end

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr/jobs/new
  # -------------------------------------------------------------------------------------------------------------------
  def new
    @job = @company.jobs.new
    render layout: 'application'
  end

  # -------------------------------------------------------------------------------------------------------------------
  # GET /jobs/1/edit
  # -------------------------------------------------------------------------------------------------------------------
  def edit
    render layout: 'application'
  end

  # -------------------------------------------------------------------------------------------------------------------
  # POST /companies/:company_id/jobs
  # -------------------------------------------------------------------------------------------------------------------
  def create
    @job = @company.jobs.new(job_params)

    if @job.save
      redirect_to [@company, @job], notice: 'Job was successfully created.'
    else
      render :new, layout: 'application'
    end
  end

  # -------------------------------------------------------------------------------------------------------------------
  # PATCH/PUT /jobs/1
  # -------------------------------------------------------------------------------------------------------------------
  def update
    if @job.update(job_params)
      redirect_to [@company, @job], notice: 'Job was successfully updated.'
    else
      render :edit, layout: 'application'
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
