class ApplicationController < ActionController::Base

  include UrlHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise redirect to companies index view after logging in
  def after_sign_in_path_for(resource)
    dashboard_path
	end

end
