class ApplicationsController < ApplicationController

  before_action :load_company
  before_action :set_job
  layout 'external'

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr/jobs/:id/apply
  # -------------------------------------------------------------------------------------------------------------------
  def new
    @application = Application.new
  end

  # -------------------------------------------------------------------------------------------------------------------
  # POST :subdomain.pinpoint.hr/jobs/:id/apply
  # -------------------------------------------------------------------------------------------------------------------
  def create
    @application = @job.application.new(application_params)

    if @application.save
      redirect_to root_url(subdomain: @company.subdomain), notice: 'Thanks for your application. Someone will be in touch with you shortly'
    else
      render 'new'
    end

  end

  # -------------------------------------------------------------------------------------------------------------------
  # PRIVATE
  # -------------------------------------------------------------------------------------------------------------------
  private

  def set_job
    @job = Job.find(params[:id])
  end

  def application_params
    params.require(:application).permit(:name, :email)
  end


end