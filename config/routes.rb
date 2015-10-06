Rails.application.routes.draw do

  root 'root#index'

  # auth
  get  '/access' => 'access#access', as: :access

  post '/access/login'  => 'access#do_login',  as: :login_user
  post '/access/logout' => 'access#do_logout', as: :logout_user
  post '/access/signup' => 'access#do_signup', as: :signup_user

  get  '/access/forgot_password' => 'access#forgot_password', as: :forgot_password
  post '/access/forgot_password' => 'access#do_forgot_password'

  get  '/access/reset_password' => 'access#reset_password', as: :reset_password
  post '/access/reset_password' => 'access#do_reset_password'

  # profile
  get '/profile' => 'profile#index', as: :profile

  get  '/profile/change_display_name' => 'profile#change_display_name', as: :change_display_name
  post '/profile/change_display_name' => 'profile#do_change_display_name'

  get  '/profile/change_password' => 'profile#change_password', as: :change_password
  post '/profile/change_password' => 'profile#do_change_password'

  get  '/profile/change_email_address' => 'profile#change_email_address', as: :change_email_address
  post '/profile/change_email_address' => 'profile#do_change_email_address'

  # about
  get '/about'          => 'about#index', as: :about
  get '/about/legal'    => 'about#legal', as: :about_legal
  get '/about/tutorial' => 'about#tutorial', as: :about_tutorial
  get '/about/how_it_works' => 'about#how_it_works', as: :about_how_it_works

end
