module Admin

  class CompanyAdministratorsController < ApplicationController

    before_action :authenticate_user!
    before_action :load_company

    # -------------------------------------------------------------------------------------------------------------------
    # POST :subdomain.pinpoint.hr/admin/company_administrators
    # -------------------------------------------------------------------------------------------------------------------
    def create
      @user = User.find(params[:user_id])
      if @company.users.count + 1 <= Company::PLANS[@company.plan_id].max_users
        @company.users.create(@user)
      else

      end
    end

    # -------------------------------------------------------------------------------------------------------------------
    # DELETE :subdomain.pinpoint.hr/admin/company_administrators/:id
    # -------------------------------------------------------------------------------------------------------------------
    def destroy
      @user = User.find(params[:id])
      @company.users.destroy(@user)
    end

    # -------------------------------------------------------------------------------------------------------------------
    # PRIVATE
    # -------------------------------------------------------------------------------------------------------------------
    private

  end

end