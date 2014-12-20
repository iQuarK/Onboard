module Admin

  class CompaniesController < ApplicationController

    before_action :authenticate_user!
    before_action :load_company

    # -------------------------------------------------------------------------------------------------------------------
    # GET :subdomain.pinpoint.hr/admin
    # -------------------------------------------------------------------------------------------------------------------
    def show
    end

    # -------------------------------------------------------------------------------------------------------------------
    # GET :subdomain.pinpoint.hr/admin/edit
    # -------------------------------------------------------------------------------------------------------------------
    def edit
    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH/PUT :subdomain.pinpoint.hr/admin
    # -------------------------------------------------------------------------------------------------------------------
    def update
      if @company.update(company_params)
        redirect_to admin_url(subdomain: @company.subdomain), notice: 'Company was successfully updated.'
      else
        render :edit
      end
    end

    # -------------------------------------------------------------------------------------------------------------------
    # DELETE :subdomain.pinpoint.hr/admin
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

  end

end
