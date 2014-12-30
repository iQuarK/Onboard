class UserMailer < ActionMailer::Base

  def welcome(user)
    @user = user
    mail(
      subject: 'Welcome',
      to: @user.email,
      track_opens: 'true'
    )
  end

  def new_applicant(user)
    @user = user
    mail(
      subject: 'New Applicant',
      to: @user.email,
      track_opens: 'true'
    )
  end

  def new_job(user)
    @user = user
    mail(
      subject: 'New Job Posting',
      to: @user.email,
      track_opens: 'true'
    )
  end

  def new_hire(user)
    @user = user
    mail(
      subject: 'New Hire',
      to: @user.email,
      track_opens: 'true'
    )
  end

  def marketing_3_day(user)
    @user = user
    mail(
      subject: '10 Things that you really cared about in 2014',
      to: @user.email,
      track_opens: 'true'
    )
  end

  def marketing_7_day(user)
    @user = user
    mail(
      subject: '16 Hilarious one star reviews of recruitment agencies',
      to: @user.email,
      track_opens: 'true'
    )
  end

  def marketing_14_day(user)
    @user = user
    mail(
      subject: 'The 11 most perfectly designed job postings',
      to: @user.email,
      track_opens: 'true'
    )
  end

end
