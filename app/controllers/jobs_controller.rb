class JobsController < ApplicationController

  before_action :load_company
  before_action :external_redirect_inactive_company
  before_action :set_job, only: [:show]

  layout 'external'

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr/jobs
  # -------------------------------------------------------------------------------------------------------------------
  def index
    @jobs = @company.jobs.all
  end

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr/jobs/:id
  # -------------------------------------------------------------------------------------------------------------------
  def show
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Private
  # -------------------------------------------------------------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = @company.jobs.find(params[:id])
  end

end
