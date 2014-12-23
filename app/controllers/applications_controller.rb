class ApplicationsController < ApplicationController

  before_action :load_company
  before_action :set_job
  layout 'external'

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr/jobs/:id/apply
  # -------------------------------------------------------------------------------------------------------------------
  def new
    @application = Application.new

    # Do LinkedIn Stuff if we have a token
    if !session[:atoken].nil?

      api_key = '777qx8iibhqxx9'
      secret_key = 'EgdQSrwcyOaImzEH'

      client = LinkedIn::Client.new(api_key, secret_key)
      client.authorize_from_access(session[:atoken], session[:asecret])
      @profile = client.profile
      # ap @profile

    end

  end

  # -------------------------------------------------------------------------------------------------------------------
  # POST :subdomain.pinpoint.hr/jobs/:id/apply
  # -------------------------------------------------------------------------------------------------------------------
  def create
    @application = @job.applications.new(application_params)

    if @application.save
      redirect_to root_url(subdomain: @company.subdomain), notice: 'Thanks for your application. Someone will be in touch with you shortly'
    else
      render 'new'
    end

  end

  # -------------------------------------------------------------------------------------------------------------------
  # this
  # -------------------------------------------------------------------------------------------------------------------
  def auth

    api_key = '777qx8iibhqxx9'
    secret_key = 'EgdQSrwcyOaImzEH'
    user_token = 'a1cd8fb0-4131-48c2-b467-04ccf09a0960'
    user_secret = '64729009-f56a-4b0f-8550-b4a242c12344'

    # get your api keys at https://www.linkedin.com/secure/developer
    client = LinkedIn::Client.new(api_key, secret_key)

    # If you want to use one of the scopes from linkedin you have to pass it in at this point
    # You can learn more about it here: http://developer.linkedin.com/documents/authentication
    request_token = client.request_token(oauth_callback: auth_callback_job_url(@job, subdomain: @company.subdomain))
    # request_token = client.request_token({}, :scope => "r_basicprofile+r_emailaddress")

    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret

    # to test from your desktop, open the following url in your browser
    # and record the pin it gives you
    redirect_to request_token.authorize_url
    # => "https://api.linkedin.com/uas/oauth/authorize?oauth_token=<generated_token>"

    # then fetch your access keys
    # client.authorize_from_request(rtoken, rsecret, pin)
    # => ["OU812", "8675309"] # <= save these for future requests

    # or authorize from previously fetched access keys
    # client.authorize_from_access("OU812", "8675309")

  end

  # -------------------------------------------------------------------------------------------------------------------
  # this
  # -------------------------------------------------------------------------------------------------------------------
  def auth_callback

    api_key = '777qx8iibhqxx9'
    secret_key = 'EgdQSrwcyOaImzEH'

    client = LinkedIn::Client.new(api_key, secret_key)
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    end
    redirect_to apply_job_url(subdomain: @company.subdomain)

  end

  # -------------------------------------------------------------------------------------------------------------------
  # PRIVATE
  # -------------------------------------------------------------------------------------------------------------------
  private

  def set_job
    @job = Job.find(params[:id])
  end

  def application_params
    params.require(:application).permit(:name, :email)
  end


end