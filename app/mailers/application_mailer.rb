class ApplicationMailer < ActionMailer::Base

  def thanks(application)
    @application = application
    mail(
      subject: 'Application Received',
      to: @application.email,
      track_opens: 'true'
    )
  end

  def reject(application)
    @application = application
    mail(
      subject: 'Application Update',
      to: @application.email,
      track_opens: 'true'
    )
  end

  def interview_invite(application)
    @application = application
    mail(
      subject: 'Application Update',
      to: @application.email,
      track_opens: 'true'
    )
  end

  def info_request(application)
    @application = application
    mail(
      subject: 'Application Update',
      to: @application.email,
      track_opens: 'true'
    )
  end

  def hire(application)
    @application = application
    mail(
      subject: 'Application Update',
      to: @application.email,
      track_opens: 'true'
    )
  end

end
