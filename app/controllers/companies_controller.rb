class CompaniesController < ApplicationController

  before_action :load_company, only: [:show]

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr
  # -------------------------------------------------------------------------------------------------------------------
  def show
    render layout: 'external'
  end

  # -------------------------------------------------------------------------------------------------------------------
  # GET /companies/new
  # -------------------------------------------------------------------------------------------------------------------
  def new
    @company = Company.new
    render layout: 'application'
  end

  # -------------------------------------------------------------------------------------------------------------------
  # POST /companies
  # -------------------------------------------------------------------------------------------------------------------
  def create
    @company = Company.new(company_params)

    if @company.save
      @company.company_administrators.create(user_id: current_user.id)
      redirect_to admin_url(subdomain: @company.subdomain), notice: 'Company was successfully created.'
    else
      render :new
    end
  end

  # -------------------------------------------------------------------------------------------------------------------
  # PRIVATE
  # -------------------------------------------------------------------------------------------------------------------
  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    params.require(:company).permit(:name, :subdomain, :description, :industry, :location, :website)
  end

end
