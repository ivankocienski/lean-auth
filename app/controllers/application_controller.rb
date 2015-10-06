class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :auth 

  private

  def user_must_be_logged_in!
    if not auth.logged_in?
      flash[:error] = 'You must be logged in to access that page'
      redirect_to root_path
    end
  end

  def user_must_NOT_be_logged_in!
    if auth.logged_in?
      flash[:error] = 'You must not be logged in to access that page'
      redirect_to root_path
    end
  end

  def redirect_back( to = nil )
    redirect_to :back

  rescue ActionController::RedirectBackError
    redirect_to( to || root_path )
  end

  def auth
    @authenticator ||= Authenticator.new(session)
  end

end
