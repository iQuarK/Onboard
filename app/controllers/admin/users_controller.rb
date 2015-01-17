module Admin

  class UsersController < ApplicationController

    before_action :authenticate_user!
    before_action :load_company
    before_action :set_user

    def edit

    end

    def update

      if @user.update(user_params)
        redirect_to admin_profile_url(subdomain: @company.subdomain), notice: "Profile was successfully updated"
      else
        render 'edit'
      end

    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def set_user
      @user = current_user
    end

  end

end