module Admin

  class ApplicationsController < ApplicationController

    before_action :load_company
    before_action :internal_redirect_inactive_company
    before_action :set_job
    before_action :set_application

    # -------------------------------------------------------------------------------------------------------------------
    # GET :subdomain.pinpoint.hr/admin/jobs/:job_id/applications/:id
    # -------------------------------------------------------------------------------------------------------------------
    def show

      # Get LinkedIn data if available
      if @application.linkedin_token.present? && @application.linkedin_secret.present?

        # Create LinkedIn Client
        client = LinkedIn::Client.new(Rails.application.secrets.linkedin_api_key, Rails.application.secrets.linkedin_secret_key)

        # Authorise using previously gained tokens
        client.authorize_from_access(@application.linkedin_token, @application.linkedin_secret)

        # Retrieve data using API call
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
          # "three-current-positions",
          # "three-past-positions",
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

      end

    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH :subdomain.pinpoint.hr/admin/jobs/:job_id/applications/:id/reject
    # -------------------------------------------------------------------------------------------------------------------
    def reject
      @application.update_attributes(stage: 1)
      redirect_to admin_job_url(@job, subdomain: @company.subdomain)
    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH :subdomain.pinpoint.hr/admin/jobs/:job_id/applications/:id/review
    # -------------------------------------------------------------------------------------------------------------------
    def review
      @application.update_attributes(stage: 2)
      redirect_to admin_job_url(@job, subdomain: @company.subdomain)
    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH :subdomain.pinpoint.hr/admin/jobs/:job_id/applications/:id/interview
    # -------------------------------------------------------------------------------------------------------------------
    def interview
      @application.update_attributes(stage: 3)
      redirect_to admin_job_url(@job, subdomain: @company.subdomain)
    end

    # -------------------------------------------------------------------------------------------------------------------
    # PATCH :subdomain.pinpoint.hr/admin/jobs/:job_id/applications/:id/hire
    # -------------------------------------------------------------------------------------------------------------------
    def hire
      @application.update_attributes(stage: 4)
      redirect_to admin_job_url(@job, subdomain: @company.subdomain)
    end

    # -------------------------------------------------------------------------------------------------------------------
    # PRIVATE
    # -------------------------------------------------------------------------------------------------------------------
    private

    def set_job
      @job = Job.find(params[:job_id])
    end

    def set_application
      @application = @job.applications.find(params[:id])
    end

  end

end