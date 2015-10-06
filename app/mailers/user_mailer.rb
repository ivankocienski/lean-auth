class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    @url  = access_path( host: 'example.com' )

    mail to: @user.email, subject: 'Welcome to Moodifique'
  end

  def reset_password(user)
    @user = user
    @url  = reset_password_url( host: 'example.com', token: user.forgot_password_token )

    mail to: @user.email, subject: 'Welcome to My Awesome Site'
  end

end
