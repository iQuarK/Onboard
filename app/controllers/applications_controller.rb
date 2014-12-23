class ApplicationsController < ApplicationController

  before_action :load_company
  before_action :set_job
  before_action :set_application, only: [:auth, :auth_callback]
  layout 'external'

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr/jobs/:id/apply
  # -------------------------------------------------------------------------------------------------------------------
  def new
    @application = Application.new

    # Do LinkedIn Stuff if we have a token
    if !session[:atoken].nil?

      client = LinkedIn::Client.new(Rails.application.secrets.linkedin_api_key, Rails.application.secrets.linkedin_secret_key)
      client.authorize_from_access(session[:atoken], session[:asecret])
      @profile = client.profile(fields: [
        # Basic Profile Fields
        "id",
        "first-name",
        "last-name",
        "maiden-name",
        "formatted-name",
        "phonetic-first-name",
        "phonetic-last-name",
        "formatted-phonetic-name",
        "headline",
        "location",
        "industry",
        # "distance",
        # "relation-to-viewer",
        "current-share",
        "num-connections",
        "num-connections-capped",
        "summary",
        "specialties",
        "positions",
        "picture-url",
        "site-standard-profile-request",
        "api-standard-profile-request",
        "public-profile-url",
        # Email Fields
        "email_address",
        # Full Profile Fields
        "last-modified-timestamp",
        # "proposal-comments",
        "associations",
        "interests",
        "publications",
        "patents",
        "languages",
        "skills",
        "certifications",
        "educations",
        "courses",
        "volunteer",
        "three-current-positions",
        "three-past-positions",
        "num-recommenders",
        "recommendations-received",
        "following",
        "job-bookmarks",
        # "suggestions",
        "date-of-birth",
        # "member-url-resources",
        # "related-profile-views",
        "honors-awards",
        # Contact Info Fields
        "phone-numbers",
        "bound-account-types",
        "im-accounts",
        "main-address",
        "twitter-accounts",
        "primary-twitter-account",
        # Connection Fields
        # "connections",
        # Group Membership Fields
        "group-memberships"
      ])
      ap @profile

      @application.name = [@profile.first_name, @profile.last_name].join(' ')
      @application.email = @profile.email_address

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
  # GET :subdomain.pinpoint.hr/applications/:id/auth
  # -------------------------------------------------------------------------------------------------------------------
  def auth
    client = LinkedIn::Client.new(Rails.application.secrets.linkedin_api_key, Rails.application.secrets.linkedin_secret_key)
    request_token = client.request_token(oauth_callback: application_auth_callback_url(@application, subdomain: @company.subdomain))
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret
    redirect_to request_token.authorize_url
  end

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr/applications/:id/auth/callback
  # -------------------------------------------------------------------------------------------------------------------
  def auth_callback
    client = LinkedIn::Client.new(Rails.application.secrets.linkedin_api_key, Rails.application.secrets.linkedin_secret_key)
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)

      session[:atoken] = atoken
      session[:asecret] = asecret

      @application.update_attributes(linkedin_token: atoken, linkedin_secret: asecret)
    end
    redirect_to apply_job_url(subdomain: @company.subdomain)

  end

  # -------------------------------------------------------------------------------------------------------------------
  # PRIVATE
  # -------------------------------------------------------------------------------------------------------------------
  private

  def set_application
    @application = Application.find(params[:id])
  end

  def set_job
    @job = Job.find(params[:id])
  end

  def application_params
    params.require(:application).permit(:name, :email)
  end


end