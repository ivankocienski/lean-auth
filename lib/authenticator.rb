
class Authenticator

  def initialize(session)
    @session = session
  end

  def login( email, password )
    user = User.where( email: email ).first
    return false if user.nil?

    return false if not user.test_password( password )

    @session[:user_id] = user.id
    true
  end

  def logout
    @session.delete :user_id
  end

  def current_user
    return nil if not logged_in?
    @user ||= User.where( id: @session[ :user_id ]).first
  end

  def logged_in?
    return false if @session[ :user_id ].nil?

    if User.where( id: @session[ :user_id ] ).count == 0
      logout
      return false
    end

    true 
  end

  #module UserModelPasswordHelper
  #end
end

