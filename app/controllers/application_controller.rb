class ApplicationController < ActionController::Base

  include UrlHelper

  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    if @company = resource.companies.first
      admin_url(subdomain: @company.subdomain)
    else
      new_company_url(subdomain: false)
    end
	end

  # Devise redirect to home page after logging out
  def after_sign_out_path_for(resource)
    root_url(subdomain: false)
  end

  private

  def load_company
    @company = Company.find_by_subdomain!(request.subdomain)
  end

  def internal_redirect_inactive_company
    if !@company.active_subscription
      redirect_to admin_subscription_url(subdomain: @company.subdomain)
    end
  end

  def external_redirect_inactive_company
    if !@company.active_subscription
      redirect_to root_url(subdomain: @company.subdomain)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:title, :first_name, :last_name, :email, :password, :password_confirmation)
    end
  end

end
