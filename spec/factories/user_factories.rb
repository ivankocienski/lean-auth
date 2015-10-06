
FactoryGirl.define do  
  
  factory :blank_user, class: User do |u|
  end

  # This will use the User class (Admin would have been guessed)
  factory :basic_user, class: User do |u|
    u.email 'user@example.com'
    u.display_name 'Human' 
    u.password 'password'
    u.password_confirmation 'password'
  end

end
