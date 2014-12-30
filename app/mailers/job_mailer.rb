class JobMailer < ActionMailer::Base

  layout 'email_basic'

  def new_job(job)
    @job = job
    @company = @job.company
    @title = 'New Job Posting'
    recipients = @company.administrators.map(&:email).join(",")
    mail( subject: 'New Job Posting', to: recipients, track_opens: 'true' )
  end

end
