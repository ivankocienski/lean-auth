class RootController < ApplicationController
  def index
    if auth.logged_in?
      # do some logged in stuff here with auth.current_user
    end
  end
end
