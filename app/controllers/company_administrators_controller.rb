class CompanyAdministratorsController < ApplicationController

  before_action :authenticate_user!

  # -------------------------------------------------------------------------------------------------------------------
  # POST /companies/:company_id/company_administrators/
  # -------------------------------------------------------------------------------------------------------------------
  def create
    @company = Company.find(params[:company_id])
    @company_administrator = @company.company_administrators.create(company_investor_params)
  end

  # -----------------------------------------------------------------------------------------------------------------
  # DELETE /company_administrators/:id
  # -----------------------------------------------------------------------------------------------------------------
  def destroy
    @company_administrator = CompanyAdministrator.find(params[:id])
    @company_administrator.destroy
  end

  # -----------------------------------------------------------------------------------------------------------------
  # PRIVATE
  # -----------------------------------------------------------------------------------------------------------------
  private

  def company_administrator_params
    params.require(:company_administrator).permit(:company_id, :user_id)
  end

end
