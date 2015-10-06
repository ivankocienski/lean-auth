class AddUserForgotPasswordToken < ActiveRecord::Migration
  def change
    add_column :users, :forgot_password_token, :string
    add_column :users, :forgot_password_expires, :datetime
  end
end
