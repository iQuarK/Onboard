module Admin

  class CompaniesController < ApplicationController

    before_action :authenticate_user!
    before_action :load_company
    before_action :internal_redirect_inactive_company, except: [:subscription]

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
    # GET :subdomain.pinpoint.hr/admin/settings/subscription
    # -------------------------------------------------------------------------------------------------------------------
    def subscription

    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH :subdomain.pinpoint.hr/admin/settings/subscription/billing
    # -------------------------------------------------------------------------------------------------------------------
    def manage_subscription

      @company.stripe_card_token = company_params[:stripe_card_token]

      # If they're not active then we might be changing the plan they're on
      if !@company.active_subscription
        @company.plan_id = company_params[:plan_id]
      end

      if @company.save_with_payment(current_user.email)
        redirect_to admin_subscription_url(subdomain: @company.subdomain), notice: "Thank you for subscribing."
      else
        render :subscription
      end

    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH :subdomain.pinpoint.hr/admin/settings/subscription/plan
    # -------------------------------------------------------------------------------------------------------------------
    def update_plan

      if @company.update_plan(params[:plan_id].to_sym)
        redirect_to admin_subscription_url(subdomain: @company.subdomain), notice: 'Updated plan successfully.'
      else
        # Expecting one error to be set if this returns false
        flash[:notice] = @company.errors.messages[:base][0]
        render :subscription
      end

    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH :subdomain.pinpoint.hr/admin/settings/subscription/cancel_subscription
    # -------------------------------------------------------------------------------------------------------------------
    def cancel_subscription

      if @company.cancel_subscription(current_user.email)
        redirect_to admin_subscription_url(subdomain: @company.subdomain), notice: "You've cancelled your subscription"
      else
        render :subscription
      end

    end

    # -------------------------------------------------------------------------------------------------------------------
    # GET :subdomain.pinpoint.hr/admin/settings/team
    # -------------------------------------------------------------------------------------------------------------------
    def team

    end

    # -------------------------------------------------------------------------------------------------------------------
    # PRIVATE
    # -------------------------------------------------------------------------------------------------------------------
    private

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :description, :industry, :location, :subdomain, :website, :benefits, :plan_id, :stripe_card_token, :logo)
    end

  end

end
