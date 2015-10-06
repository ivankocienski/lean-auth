
require 'spec_helper'

describe User do 

  context 'display_name' do
    it 'is used if set' do
      u = User.new
      u.display_name = 'a-human'

      expect(u.display_name).to eq('a-human')
    end

    it 'is defaulted if not set' do
      expect( User.new.display_name ).to eq('User')
    end
  end
  
  context 'email' do
    it 'must be set' do

      u = User.new
      u.save

      expect( u.valid? ).to be false
      expect( u.errors ).to have_key( :email )

    end

    it 'must be valid' do
      u = User.new
      u.email = 'bademail' # not really
      
      expect( u.valid? ).to be false
      expect( u.errors ).to have_key( :email )
    end

    it 'must be unique' do
      u1 = User.new
      u1.email = 'user@example.com'
      u1.password = 'password'
      u1.password_confirmation = 'password'
      u1.save

      u2 = User.new
      u2.email = 'user@example.com'

      expect( u2.valid? ).to be false
      expect( u2.errors ).to have_key( :email )
    end

  end

  context 'password' do
    context 'setting' do
      it 'can be ignored if not set' do
        expect {
          User.new do |u|
            u.email = 'user@eample.com'
          end
        }.not_to raise_exception
      end

      it 'must be equal to confirmation password' do
        u = User.new
        u.email = 'user@eample.com'
        u.password = '12345'
        u.password_confirmation = ''
        expect( u.valid? ).to eq(false)
        expect( u.errors ).to have_key( :password_confirmation )

        u.password_confirmation = '12345'
        expect( u.valid? ).to eq(true)
      end

      it 'is salted and saved in DB' do
        u = User.new
        u.email = 'user@eample.com'
        u.password = '12345'
        u.password_confirmation = '12345'
        u.save
        u.reload

        expect(u.password_encoded.length > 0).to be(true)
        expect(u.password_encoded).not_to eq('12345')
        expect(u.password_salt.length > 0).to be(true)
      end
    end

    context 'verifying' do
      it 'correct positive' do
        u = User.new
        u.email = 'user@eample.com'
        u.password = '12345'
        u.password_confirmation = '12345'
        u.save
        u.reload

        expect( u.test_password('12345') ).to be true
      end

      it 'correct negative' do 
        u = User.new
        u.email = 'user@eample.com'
        u.password = '12345'
        u.password_confirmation = '12345'
        u.save
        u.reload

        expect( u.test_password('54321') ).not_to be true
      end
    end
  end
  
  context 'forgot password' do

    let( :user ) { create :basic_user }

    before :each do
      user.generate_forgot_password_token!
      user.reload
    end
    
    context 'generate_forgot_password_token' do

      it 'sets up token' do 
        expect( user.forgot_password_token ).not_to be nil
      end

      it 'sets expire timestamp' do
        db_time  = user.forgot_password_expires
        our_time = DateTime.now + User::FORGOT_PASSWORD_EXPIRE_HOURS.hours

        expect( db_time.to_i ).to eq our_time.to_i
      end
    end

    context '#find_by_forgot_password_token' do

      it 'returns user with correct token' do
        found = User.find_by_forgot_password_token( user.forgot_password_token )
        expect( found ).to eq user
      end

      it 'returns nil if token is too old' do 
        user.update_attributes! forgot_password_expires: DateTime.now - (User::FORGOT_PASSWORD_EXPIRE_HOURS + 1).hours

        found = User.find_by_forgot_password_token( user.forgot_password_token )
        expect( found ).to be nil
      end
    end

    context '#clear_forgot_password_token!' do
      it 'empties the tokens for that user' do

        user.clear_forgot_password_token!
        user.reload

        expect( user.forgot_password_token ).to eq ''
        expect( user.forgot_password_expires ).to eq nil
      end
    end

  end

end

