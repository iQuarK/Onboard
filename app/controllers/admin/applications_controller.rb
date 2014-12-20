module Admin

  class ApplicationsController < ApplicationController

    before_action :load_company
    before_action :set_job
    before_action :set_application

    # -------------------------------------------------------------------------------------------------------------------
    # GET :subdomain.pinpoint.hr/admin/jobs/:job_id/applications/:id
    # -------------------------------------------------------------------------------------------------------------------
    def show

    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH :subdomain.pinpoint.hr/admin/jobs/:job_id/applications/:id/reject
    # -------------------------------------------------------------------------------------------------------------------
    def reject
      @application.update_attributes(stage: 1)
      redirect_to admin_job_url(@job, subdomain: @company.subdomain)
    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH :subdomain.pinpoint.hr/admin/jobs/:job_id/applications/:id/review
    # -------------------------------------------------------------------------------------------------------------------
    def review
      @application.update_attributes(stage: 2)
      redirect_to admin_job_url(@job, subdomain: @company.subdomain)
    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH :subdomain.pinpoint.hr/admin/jobs/:job_id/applications/:id/interview
    # -------------------------------------------------------------------------------------------------------------------
    def interview
      @application.update_attributes(stage: 3)
      redirect_to admin_job_url(@job, subdomain: @company.subdomain)
    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH :subdomain.pinpoint.hr/admin/jobs/:job_id/applications/:id/hire
    # -------------------------------------------------------------------------------------------------------------------
    def hire
      @application.update_attributes(stage: 4)
      redirect_to admin_job_url(@job, subdomain: @company.subdomain)
    end

    # -------------------------------------------------------------------------------------------------------------------
    # PRIVATE
    # -------------------------------------------------------------------------------------------------------------------
    private

    def set_job
      @job = Job.find(params[:job_id])
    end

    def set_application
      @application = @job.applications.find(params[:id])
    end

  end

end