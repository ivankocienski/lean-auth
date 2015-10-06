class AccessController < ApplicationController

  before_filter :user_must_NOT_be_logged_in!, only: [
    :access,
    :do_login, 
    :do_signup,
    :forgot_password,
    :do_forgot_password,
    :reset_password,
    :do_reset_password
  ]

  before_filter :user_must_be_logged_in!, only: [ :do_logout ]

  def access
    @new_user = User.new
  end

  def do_login
    @new_user = User.new

    email    = (params[:login] || {} )[:email]
    password = (params[:login] || {} )[:password]

    if auth.login( email, password )
      flash[:notice] = "Hello, #{auth.current_user.display_name}, welcome back"
      redirect_to root_path
    else
      flash.now[:error] = 'Login failed'
      @login_error = true
      render :access
    end
  end

  def do_logout
    auth.logout
    flash[:info] = 'You have logged out. Come back soon, ya\'ll'
    redirect_to root_path
  end

  def do_signup
    @new_user = User.new

    fields = [ :email, :password, :password_confirmation, :display_name ]
    signup = params[:signup] || {}

    fields.each do |f|
      @new_user.send "#{f}=", signup[f]
    end

    if @new_user.save
      flash[:notice] = "Hello, #{@new_user.display_name}, welcome to Moodifique"
      redirect_to root_path
      return
    end

    flash.now[:error] = 'Something failed whilst creating account'
    render :action => 'access' 
  end

  def forgot_password
  end

  def do_forgot_password

    fpp = params[:forgot_password] || {}

    user = User.where( email: fpp[:email] ).first

    if user.nil?
      flash.now[:error] = 'Could not find user with that email'
      render action: :forgot_password
      @post_error = true
      return
    end

    user.generate_forgot_password_token!

    #user.send_forgot_password_email

    flash[:info] = 'An email has been sent with a reset link'
    redirect_to access_path
  end

  def reset_password
    @token = params[:token]
    user   = User.find_by_forgot_password_token( @token )

    if user.nil?
      flash[:error] = 'Password reset token does not exist or has expired'
      redirect_to forgot_password_path
    end
  end

  def do_reset_password 

    fpp = params[ :reset_password ] || {}

    @reset_user = User.find_by_forgot_password_token( fpp[:token] )

    if @reset_user.nil?
      flash[:error] = 'Password reset token does not exist or has expired'
      redirect_to forgot_password_path
      return
    end

    @reset_user.password = fpp[:password]
    @reset_user.password_confirmation = fpp[:password_confirmation]

    if not @reset_user.save
      flash.now[:error] = 'Password reset failed'
      render action: 'reset_password'
      return
    end

    @reset_user.clear_forgot_password_token!

    flash[:notice] = 'Your password has been changed, please log in now'
    redirect_to access_path
  end

end
