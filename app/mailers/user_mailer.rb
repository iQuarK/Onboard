class UserMailer < ActionMailer::Base

  layout 'email_basic'

  def welcome(user)
    @user = user
    @title = "Welcome to Pinpoint"
    mail( subject: 'Welcome', to: @user.email, track_opens: 'true' )
  end

  def marketing_3_day(user)
    @user = user
    @title = "Welcome to Pinpoint"
    mail( subject: '10 Things that you really cared about in 2014', to: @user.email, track_opens: 'true' )
  end

  def marketing_7_day(user)
    @user = user
    @title = "Welcome to Pinpoint"
    mail( subject: '16 Hilarious one star reviews of recruitment agencies', to: @user.email, track_opens: 'true' )
  end

  def marketing_14_day(user)
    @user = user
    @title = "Welcome to Pinpoint"
    mail( subject: 'The 11 most perfectly designed job postings', to: @user.email, track_opens: 'true' )
  end

end
