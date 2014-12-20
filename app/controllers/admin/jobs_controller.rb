module Admin

  class JobsController < ApplicationController

    before_action :authenticate_user!
    before_action :load_company
    before_action :set_job, only: [:show, :edit, :update, :destroy]

    # -------------------------------------------------------------------------------------------------------------------
    # GET :subdomain.pinpoint.hr/admin/jobs
    # -------------------------------------------------------------------------------------------------------------------
    def index
      @jobs = @company.jobs.all
    end

    # -------------------------------------------------------------------------------------------------------------------
    # GET :subdomain.pinpoint.hr/admin/jobs/1
    # -------------------------------------------------------------------------------------------------------------------
    def show
    end

    # -------------------------------------------------------------------------------------------------------------------
    # GET :subdomain.pinpoint.hr/admin/jobs/new
    # -------------------------------------------------------------------------------------------------------------------
    def new
      @job = @company.jobs.new
    end

    # -------------------------------------------------------------------------------------------------------------------
    # GET :subdomain.pinpoint.hr/admin/jobs/:id/edit
    # -------------------------------------------------------------------------------------------------------------------
    def edit
    end

    # -------------------------------------------------------------------------------------------------------------------
    # POST :subdomain.pinpoint.hr/admin/jobs
    # -------------------------------------------------------------------------------------------------------------------
    def create
      @job = @company.jobs.new(job_params)

      if @job.save
        redirect_to admin_job_url(@job, subdomain: @company.subdomain), notice: 'Job was successfully created.'
      else
        render :new
      end
    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH/PUT :subdomain.pinpoint.hr/admin/jobs/:id
    # -------------------------------------------------------------------------------------------------------------------
    def update
      if @job.update(job_params)
        redirect_to admin_job_url(@job, subdomain: @company.subdomain), notice: 'Job was successfully updated.'
      else
        render :edit
      end
    end

    # -------------------------------------------------------------------------------------------------------------------
    # DELETE :subdomain.pinpoint.hr/admin/jobs/:id
    # -------------------------------------------------------------------------------------------------------------------
    def destroy
      @job.destroy
      redirect_to admin_jobs_path(subdomain: @company.subdomain), notice: 'Job was successfully destroyed.'
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

  end

end