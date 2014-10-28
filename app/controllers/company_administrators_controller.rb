class CompanyAdministratorsController < ApplicationController

  before_filter :authenticate_user!

  def create
    @company = Company.find(params[:company_id])
    @company_administrator = @company.company_administrator.create(company_investor_params)
  end

  # -----------------------------------------------------------------------------------------------------------------
  # DELETE /company_investors/:id
  # -----------------------------------------------------------------------------------------------------------------
  def destroy

    @company_investor = CompanyInvestor.find(params[:id])
    @company_investor.destroy

  end

  # -----------------------------------------------------------------------------------------------------------------
  # PRIVATE
  # -----------------------------------------------------------------------------------------------------------------
  private

  def company_administrator_params
    params.require(:company_administrator).permit(:company_id, :user_id)
  end

end
