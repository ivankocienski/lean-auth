require 'rails_helper'

RSpec.describe AccessController, type: :controller do

  context 'do_login' do

    it 'passes login info to auth' do 
      expect_any_instance_of(Authenticator).to receive(:login).with( 'user@example.com', '1234' )

      post :do_login, { 
        login: { 
          email: 'user@example.com',
          password: '1234'
        } }
    end

    it 'redirects if logged in' do
      user = create(:basic_user)

      allow_any_instance_of(Authenticator).to receive(:login).and_return(true)
      allow_any_instance_of(Authenticator).to receive(:current_user).and_return(user)

      post :do_login

      expect( flash[:notice] ).to eq "Hello, #{user.display_name}, welcome back"
      expect( response ).to redirect_to( root_path )
    end

    it 'renders if log in fails' do

      allow_any_instance_of(Authenticator).to receive(:login).and_return(false)

      post :do_login

      expect( flash.now[:error] ).to eq "Login failed"
      expect( response ).to render_template( "access/access" )
    end
  end

  context 'do_signup' do

    it 'sets up a new user' do

      post :do_signup, {
        signup: {
          email: 'new-user@example.com',
          display_name: 'new user',
          password: 'passwordpassword',
          password_confirmation: 'passwordpassword'
        }}

      u = User.first
      expect( u.email ).to eq 'new-user@example.com'
      expect( u.display_name ).to eq 'new user'
    end

    it 'redrirects if successful' do

      #allow_any_instance_of( User ).to receive( :save ).and_return(true)

      post :do_signup, {

        signup: {
          email: 'new-user@example.com',
          display_name: 'new user',
          password: 'passwordpassword',
          password_confirmation: 'passwordpassword'
        }}

      expect( flash[:notice] ).to eq "Hello, new user, welcome to Moodifique"
      expect( response ).to redirect_to( root_path )
    end

    it 'renders if failed' do      
      allow_any_instance_of( User ).to receive( :save ).and_return(false)

      post :do_signup

      expect( flash.now[:error] ).to eq "Something failed whilst creating account"
      expect( response ).to render_template( "access/access" )
    end

  end

  context 'do_forgot_password' do

    context 'non existant email' do
      it 'kicks back to form page' do

        post :do_forgot_password, { forgot_password: { email: 'nobody@example.com' } }

        expect( flash.now[:error] ).to eq "Could not find user with that email"
        expect( response ).to render_template( "access/forgot_password" )
      end
    end

    context 'user email exists' do

      let( :user ) { create :basic_user }

      it 'redirects user back' do
        post :do_forgot_password, { forgot_password: { email: user.email } }

        expect( flash[:info] ).to eq "An email has been sent with a reset link"
        expect( response ).to redirect_to( access_path )
      end

      it 'sets up tokens' do 
        expect_any_instance_of(User).to receive(:generate_forgot_password_token!)
        post :do_forgot_password, { forgot_password: { email: user.email } }
      end

      it 'sends email' #do
        #pending 
        #expect_any_instance_of(User).to receive(:send_forgot_password_email)
        #post :do_forgot_password, { forgot_password: { email: user.email } }
      #end
    end

  end

  context 'reset password page' do
    it 'sets up token value' do
      get :reset_password, { token: 'atoken' } 
      expect( assigns[:token] ).to eq 'atoken'
    end
  end

  context 'reset password operator' do

    let( :user ) { create :basic_user }

    it 'fails if it cannot find token' do

      post :do_reset_password

      expect( flash[:error] ).to eq 'Password reset token does not exist or has expired'
      expect( response ).to redirect_to( forgot_password_path )
    end

    context '(with reset token)' do
      before :each do
        user.generate_forgot_password_token!
      end

      it 'fails if there was a problem with password change' do

        old_password = user.password_encoded

        post :do_reset_password, {
          reset_password: {
            token: user.forgot_password_token,
            password: '1234',
            password_confirmation: '4321'
          }}

        expect( flash.now[:error] ).to eq 'Password reset failed'
        expect( response ).to render_template( 'access/reset_password' )
        expect( assigns[:reset_user].errors ).not_to be_empty

        user.reload 
        expect( user.password_encoded ).to eq old_password
      end

      it 'changes password' do
        old_password = user.password_encoded

        post :do_reset_password, {
          reset_password: {
            token: user.forgot_password_token,
            password: 'newpasswordhere',
            password_confirmation: 'newpasswordhere'
          }}

        user.reload 
        expect( user.password_encoded ).not_to eq old_password
      end

      it 'clears password reset token upon success' do
        post :do_reset_password, {
          reset_password: {
            token: user.forgot_password_token,
            password: 'newpasswordhere',
            password_confirmation: 'newpasswordhere'
          }}

        user.reload 
        expect( user.forgot_password_token ).to eq ''
        expect( user.forgot_password_expires ).to eq nil
      end
    end # context (with reset token)
  end

end
