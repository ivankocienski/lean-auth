require 'spec_helper'

describe Authenticator do

  let( :user ) { create :basic_user }

  let( :session ) { {} }
  let( :auth ) { Authenticator.new( session ) }

  context '#login' do
    it 'rejects if email is not found' do 
      res = auth.login( 'noone@nothere.com', '' ) 
      expect(res).to eq false
    end

    it 'rejects if password is wrong' do
      res = auth.login( user.email, 'notgood' )
      expect(res).to eq false 
    end

    it 'sets session if sucessful' do
      res = auth.login( user.email, 'password' )
      expect(res).to eq true
      expect(session[:user_id]).to eq user.id
    end
  end

  context '#logout' do
    it 'clears the session' do
      session[:user_id] = 1234
      auth.logout
      expect( session[:user_id] ).to be_nil
    end
  end

  context '#current_user' do
    it 'returns nil if not logged in' do
      expect( auth.current_user ).to be_nil
    end
    
    it 'returns nil if user does not exist' do
      session[:user_id] = 5678
      expect( auth.current_user ).to be_nil
    end

    it 'returns user that was in session' do
      session[:user_id] = user.id
      expect( auth.current_user ).to eq user
    end
  end

  context '#logged_in?' do 
    it 'returns false if not logged in' do
      expect( auth.logged_in? ).to be false
    end
    
    it 'returns false if user does not exist' do
      session[:user_id] = 6543
      expect( auth.logged_in? ).to be false 
      expect( session[:user_id] ).to be nil
    end

    it 'returns user that was in session' do
      session[:user_id] = user.id
      expect( auth.logged_in? ).to be true 
    end
  end
end
