require 'spec_helper'

feature 'Forgot password' do

  include Common

  let( :user ) { create :basic_user }

  scenario 'reseting my password from the login page' do

    visit '/'
    click_link 'Access'
    click_link 'Forgot password?'

    fill_in 'Email', with: user.email
    click_button 'Reset'

    expect(page).to have_content( 'An email has been sent with a reset link' )

  end

  scenario 'clicking on reset password link' do

    u = create :basic_user
    u.generate_forgot_password_token!

    visit "/access/reset_password?token=#{u.forgot_password_token}"

    fill_in 'Password', with: 'newnewpassword'
    fill_in 'Password Confirmation', with: 'newnewpassword'

    click_button 'Change password'

    expect(page).to have_content( 'Your password has been changed, please log in now' )

  end

end

