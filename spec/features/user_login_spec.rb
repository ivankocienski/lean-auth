
require 'spec_helper'

feature 'Users logging in:' do

  include Common

  scenario 'can log in' do

    create :basic_user

    visit '/'

    # this is defined for more general use in 
    # Common as start_login but is here as steps
    # for completeness
    click_link 'Access'
    fill_in 'login_email', with: 'user@example.com'
    fill_in 'login_password', with: 'password'
    click_button 'Log in'

    expect(page).to have_content( 'Hello, Human, welcome back' )
  end 

  scenario 'can log out' do

    create :basic_user 
    start_login

    click_button 'Log out'
    expect(page).to have_content( 'You have logged out. Come back soon, ya\'ll' )
    expect(page).not_to have_content( 'Human' )
  end
end

