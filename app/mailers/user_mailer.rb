class UserMailer < ActionMailer::Base
  
  default from: "tom@hacquoil.com"

  def welcome(user)
    @user = user
    mail(
      subject: 'Welcome',
      to: @user.email,
      track_opens: 'true'
    )
  end

end
