require 'spec_helper'

feature 'Profile' do

  include Common

  let( :user ) { create :basic_user }

  before :each do 
    user # must be created first
    start_login
  end

  context 'viewing' do
    it 'should show my display name' do
      expect( page ).to have_content( user.display_name )
    end

    it 'seeing some stats' do
      click_link 'Profile'

      expect( page ).to have_content( "Human's profile" )
      expect( page ).to have_content( "Registered on #{user.created_at.strftime( '%B %d, %Y')}" )
    end
  end

  context 'changing display name' do
    it 'works' do
      click_link 'Profile'
      click_link 'Change display name'

      fill_in 'Display name', with: 'NewName'
      click_button 'Save'

      expect(page).to have_content( "NewName's profile" )
    end
  end

  context 'changing password' do
    it 'works' do
      click_link 'Profile'
      click_link 'Change password'

      fill_in 'Old password', with: 'password'
      fill_in 'New password', with: 'newpassword'
      fill_in 'Confirm new password', with: 'newpassword'
      click_button 'Save'

      expect(page).to have_content('Password has been changed' )

      # should we log out and try to log in again using the old and then new passwords?
    end
  end

  context 'changing email address' do
    it 'works' do
      click_link 'Profile'
      click_link 'Change email address'

      fill_in 'Email address', with: 'different-user@example.com'
      click_button 'Save'

      expect(page).to have_content('Email address has been changed')
    end
  end

end

