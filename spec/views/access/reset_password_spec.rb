require 'spec_helper'

describe 'access/reset_password', type: :view do

  context 'errors' do
    it 'are shown' do

      user = User.new
      user.errors.add( :password, 'is too short' )
      user.errors.add( :password_confirmation, 'did not match' )
      assign( :reset_user, user )
      render

      expect( rendered ).to have_content( 'is too short' )
      expect( rendered ).to have_content( 'did not match' )
    end
  end

  context 'reset form' do
    it 'sets up token field sent to it' do
      assign( :token, '123456' )
      render

      expect( rendered ).to have_xpath( "//input[@type='hidden' and @value='123456']" ) 
    end 
  end
end
