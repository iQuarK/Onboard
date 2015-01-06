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
    # GET :subdomain.pinpoint.hr/admin/subscription
    # -------------------------------------------------------------------------------------------------------------------
    def subscription

    end

    # -------------------------------------------------------------------------------------------------------------------
    # POST :subdomain.pinpoint.hr/admin/subscription
    # -------------------------------------------------------------------------------------------------------------------
    def manage_subscription
      if @company.save_with_payment(current_user.email)
        redirect_to admin_subscription_url(subdomain: @company.subdomain), :notice => "Thank you for subscribing!"
      else
        render :subscription
      end
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
      params.require(:company).permit(:name, :description, :industry, :location, :subdomain, :website, :benefits, :plan_id, :stripe_card_token)
    end

  end

end
