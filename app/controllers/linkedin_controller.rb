class LinkedinController < ApplicationController
  
  before_action :load_company

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr/linkedin/auth
  # -------------------------------------------------------------------------------------------------------------------
  def auth
    client = LinkedIn::Client.new(Rails.application.secrets.linkedin_api_key, Rails.application.secrets.linkedin_secret_key)
    request_token = client.request_token(oauth_callback: linkedin_callback_url(subdomain: @company.subdomain))
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret
    redirect_to request_token.authorize_url
  end

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr/linkedin/callback
  # -------------------------------------------------------------------------------------------------------------------
  def callback
    client = LinkedIn::Client.new(Rails.application.secrets.linkedin_api_key, Rails.application.secrets.linkedin_secret_key)
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)

      session[:atoken] = atoken
      session[:asecret] = asecret

    end

    # We're expecting to have a job_id to send them back to, but i've put this if here just in case we don't
    if session[:job_id].nil?
      redirect_to root_url(subdomain: @company.subdomain)
    else
      redirect_to apply_job_url(Job.find(session[:job_id]), subdomain: @company.subdomain)
    end

  end

end