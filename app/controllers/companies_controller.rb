class CompaniesController < ApplicationController

  before_action :authenticate_user!, except: [:show ]
  before_action :set_company, only: [:edit, :update, :destroy]
  before_action :check_for_existing_company, only: [:new, :create]

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
  # GET /companies/1/edit
  # -------------------------------------------------------------------------------------------------------------------
  def edit
    render layout: 'application'
  end

  # -------------------------------------------------------------------------------------------------------------------
  # POST /companies
  # -------------------------------------------------------------------------------------------------------------------
  def create
    @company = Company.new(company_params)

    if @company.save
      @company.company_administrators.create(user_id: current_user.id)
      redirect_to root_url(subdomain: @company.subdomain), notice: 'Company was successfully created.'
    else
      render :new, layout: 'external'
    end
  end

  # -------------------------------------------------------------------------------------------------------------------
  # PATCH/PUT /companies/1
  # -------------------------------------------------------------------------------------------------------------------
  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      render :edit, layout: 'application'
    end
  end

  # -------------------------------------------------------------------------------------------------------------------
  # DELETE /companies/1
  # -------------------------------------------------------------------------------------------------------------------
  def destroy
    @company.destroy
    redirect_to root_url(subdomain: false), notice: 'Company was successfully destroyed.'
  end

  # -------------------------------------------------------------------------------------------------------------------
  # PRIVATE
  # -------------------------------------------------------------------------------------------------------------------
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Company.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    params.require(:company).permit(:name, :description, :industry, :location, :subdomain)
  end

  def check_for_existing_company
    if current_user.has_company?
      redirect_to dashboard_path, notice: "You already have a company"
    end
  end

end
