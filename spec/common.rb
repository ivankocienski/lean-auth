

module Common
  def start_login( with: {} )
    visit '/'

    click_link 'Access'
    fill_in 'login_email', with: (with[:email] || 'user@example.com')
    fill_in 'login_password', with: (with[:password] || 'password')
    click_button 'Log in'
  end
end

