class User < ActiveRecord::Base


  #
  # display name stuff
  #

  def display_name
    dn = attributes['display_name'] || ''
    return dn if dn.length > 0
    
    'User'
  end




  #
  # password stuff
  #

  attr_accessor :password
  attr_accessor :password_confirmation

  validates :password, confirmation: true
  validates :password, length: { minimum: 5 }, allow_nil: true

  before_save :encode_password

  def test_password(string)
    test = Digest::SHA1.hexdigest(string + self.password_salt)

    test == self.password_encoded
  end

  def encode_password
    return if @password.nil?

    self.password_salt = Digest::SHA1.hexdigest(self.email + Date.today.to_s + "moodifique")
    self.password_encoded = Digest::SHA1.hexdigest(@password + self.password_salt)
    nil 
  end




  #
  # email stuff
  #

  EMAIL_NAME_REGEX  = '[\w\.%\+\-]+'.freeze
  DOMAIN_HEAD_REGEX = '(?:[A-Z0-9\-]+\.)+'.freeze
  DOMAIN_TLD_REGEX  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'.freeze
  EMAIL_REGEX       = /\A#{EMAIL_NAME_REGEX}@#{DOMAIN_HEAD_REGEX}#{DOMAIN_TLD_REGEX}\z/i

  validates_presence_of :email, allow_nil: false
  validates_format_of :email, :with => EMAIL_REGEX
  validates :email, uniqueness: true




  #
  # forgot password stuff
  #

  FORGOT_PASSWORD_EXPIRE_HOURS = 5

  def generate_forgot_password_token!
    str = 
      self.id.to_s +
      self.email.to_s +
      DateTime.now.to_i.to_s

    self.forgot_password_token = Digest::SHA1.hexdigest(str)
    self.forgot_password_expires = DateTime.now + FORGOT_PASSWORD_EXPIRE_HOURS.hours

    save!

  end
  
  def self.find_by_forgot_password_token( tok )
    User.
      where( 'length(forgot_password_token) > 0' ).
      where( forgot_password_token: tok ).
      where( "forgot_password_expires > ?", DateTime.now - FORGOT_PASSWORD_EXPIRE_HOURS.hours ).
      first
  end

  def clear_forgot_password_token!
    update_attributes! forgot_password_token: '', forgot_password_expires: nil
  end

end
