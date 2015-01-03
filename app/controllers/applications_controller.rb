class ApplicationsController < ApplicationController

  before_action :load_company
  before_action :set_job
  layout 'external'

  # -------------------------------------------------------------------------------------------------------------------
  # GET :subdomain.pinpoint.hr/jobs/:id/apply
  # -------------------------------------------------------------------------------------------------------------------
  def new
    @application = Application.new

    # @attachable = @application
    @attachments = @application.attachments.build

    # If they authenticate with LinkedIn, we need to know what Job to link take them back to
    session[:job_id] = @job.id

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
      # ap @profile

      # Use this data to populate the form
      @application.name = [@profile.first_name, @profile.last_name].join(' ')
      @application.email = @profile.email_address

    end

  end

  # -------------------------------------------------------------------------------------------------------------------
  # POST :subdomain.pinpoint.hr/jobs/:id/apply
  # -------------------------------------------------------------------------------------------------------------------
  def create
    @application = @job.applications.new(application_params)

    # If theyve authenticated with LinkedIn then we want to save their token and key
    if session[:atoken].present?
      @application.linkedin_token = session[:atoken]
      @application.linkedin_secret = session[:asecret]
    end

    if @application.save

      # Due to multiple file select field, we need this to be able to save multiple attachments
      params[:attachments]['attachment'].each do |attachment|
        @attachment = @application.attachments.create(attachment: attachment)
      end

      redirect_to root_url(subdomain: @company.subdomain), notice: 'Thanks for your application. Someone will be in touch with you shortly'
    else
      render 'new'
    end

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
    params.require(:application).permit(
      :name,
      :email,
      :phone,
      :address,
      :summary,
      :resume,
      :resume_cache,
      attachments_attributes: [:attachment]
    )
  end


end