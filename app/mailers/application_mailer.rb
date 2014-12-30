class ApplicationMailer < ActionMailer::Base

  layout 'email_basic'

  # -------------------------------------------------------------------------------------------------------------------
  # Emails that get sent to administrators
  # -------------------------------------------------------------------------------------------------------------------
  def new_application(application)
    load_resources(application)
    @title = 'New Job Applicant'
    mail( subject: 'New Applicant', to: company_administrators, track_opens: 'true' )
  end

  def new_hire(application)
    load_resources(application)
    @title = 'New Hire'
    mail( subject: 'New Hire', to: company_administrators, track_opens: 'true' )
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Emails that get sent to actual applicants
  # -------------------------------------------------------------------------------------------------------------------

  def thanks(application)
    load_resources(application)
    mail( subject: 'Application Received', to: @application.email, track_opens: 'true' )
  end

  def reject(application)
    load_resources(application)
    mail( subject: 'Application Update', to: @application.email, track_opens: 'true' )
  end

  def interview_invite(application)
    load_resources(application)
    mail( subject: 'Application Update', to: @application.email, track_opens: 'true' )
  end

  def info_request(application)
    load_resources(application)
    mail( subject: 'Application Update', to: @application.email, track_opens: 'true' )
  end

  def hire(application)
    load_resources(application)
    mail( subject: 'Application Update', to: @application.email, track_opens: 'true' )
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Private methods
  # -------------------------------------------------------------------------------------------------------------------
  private

  def load_resources(application)
    @application = application
    @job = @application.job
    @company = @job.company
  end

  def company_administrators
    @company.administrators.map(&:email).join(",")
  end

end
