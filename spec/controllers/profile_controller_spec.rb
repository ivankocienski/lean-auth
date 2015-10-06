require 'rails_helper'

RSpec.describe ProfileController, type: :controller do

  let( :user ) { create :basic_user }

  let( :session_args ) { { user_id: user.id } }

  context 'do_change_display_name' do
    
    let( :post_args ) { { user: {} } }

    it 'changes display name' do

      post_args[:user][:display_name] = 'New Name'

      post :do_change_display_name, post_args, session_args

      expect( flash[:notice] ).to eq 'Your display name has been changed'
      expect( response ).to redirect_to( profile_path )

      user.reload
      expect( user.display_name ).to eq 'New Name' 
    end

    it 'renders feedback if something fails' do

      old_display_name = user.display_name

      allow_any_instance_of( User ).to receive( :save ).and_return(false)

      post :do_change_display_name, post_args, session_args

      expect( flash.now[:error] ).to eq 'Update of display name failed'
      expect( response ).to render_template( 'profile/change_display_name' )

      user.reload

      expect( user.display_name ).to eq old_display_name
    end
  end # do_change_display_name

  context 'do_change_password' do

    let( :post_args ) { { change_password: {} } }

    context 'with wrong password' do
      it 'rejects update properly' do

        old_password = user.password_encoded

        post_args[:change_password][:old_password] = 'Not this password'
        post :do_change_password, post_args, session_args

        expect( flash.now[:error] ).to eq 'Old password was not correct'
        expect( response ).to render_template( 'profile/change_password' )

        user.reload
        expect( user.password_encoded ).to eq old_password
      end
    end

    context 'with correct password' do
      before :each do
        post_args[:change_password][:old_password] = 'password'
      end

      it 'responds if something went wrong, does not update' do
        old_password = user.password_encoded

        allow_any_instance_of( User ).to receive( :save ).and_return(false)
        post :do_change_password, post_args, session_args

        expect( flash.now[:error] ).to eq 'Could not update password'
        expect( response ).to render_template( 'profile/change_password' )

        user.reload
        expect( user.password_encoded ).to eq old_password
      end

      it 'updates user, redirects' do

        old_password = user.password_encoded

        post_args[:change_password][:new_password] = 'Not this password'
        post_args[:change_password][:confirm_new_password] = 'Not this password'
        post :do_change_password, post_args, session_args

        expect( flash[:notice] ).to eq 'Password has been changed'
        expect( response ).to redirect_to( profile_path )

        user.reload
        expect( user.password_encoded ).not_to eq old_password
      end
    end
  end # do_change_password

  context 'do_change_email_address' do

    let( :post_args ) { { change_email_address: {} } }

    it 'responds properly if something went wrong' do

      old_email = user.email

      post_args[:change_email_address][:email_address] = 'not-a-valid-email-address'
      post :do_change_email_address, post_args, session_args

      expect( flash.now[:error] ).to eq 'Failed to update email address'
      expect( response ).to render_template( 'profile/change_email_address' )

      user.reload
      expect( user.email ).to eq old_email
    end

    it 'updates email if okay' do

      post_args[:change_email_address][:email_address] = 'new-address@example.com'
      post :do_change_email_address, post_args, session_args

      expect( flash[:notice] ).to eq 'Email address has been changed'
      expect( response ).to redirect_to( profile_path )

      user.reload
      expect( user.email ).to eq 'new-address@example.com'
    end

    
  end # do_change_email_address

end
