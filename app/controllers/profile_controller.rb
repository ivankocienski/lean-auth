class ProfileController < ApplicationController

  before_filter :user_must_be_logged_in!
  before_filter :set_user

  def index
  end

  def change_display_name
  end

  def change_password
  end

  def change_email_address
  end

  def do_change_display_name

    cdnp = params[:user] || {}

    @user.display_name = cdnp[:display_name]

    if @user.save 
      flash[:notice] = 'Your display name has been changed'
      redirect_to action: 'index'
      return
    end

    @post_error = true
    flash.now[:error] = 'Update of display name failed'
    render action: :change_display_name
  end
  
  def do_change_password

    cpp = params[:change_password] || {}

    if @user.test_password( cpp[:old_password] )

      @user.password = cpp[:new_password]
      @user.password_confirmation = cpp[:confirm_new_password]

      if @user.save
        flash[:notice] = 'Password has been changed'
        redirect_to profile_path

      else
        @user.errors[:new_password] = @user.errors[:password]
        @user.errors[:confirm_new_password] = @user.errors[:password_confirmation]
        @post_error = true
        flash.now[:error] = 'Could not update password'
        render action: :change_password
      end

    else
      @user.errors[:old_password] << 'Did not match existing password'
      @post_error = true
      flash.now[:error] = 'Old password was not correct'
      render action: :change_password
    end
  end

  def do_change_email_address

    cep = params[:change_email_address] || {}

    @user.email = cep[:email_address]
    
    if @user.save
      flash[:notice] = 'Email address has been changed'
      redirect_to profile_path
      return
    end

    @post_error = true
    flash.now[:error] = 'Failed to update email address'
    render action: :change_email_address
  end

  private

  def set_user
    @user = auth.current_user
  end
  
end
