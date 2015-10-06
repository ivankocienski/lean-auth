class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :email, default: ''
      t.string :password_encoded, default: ''
      t.string :password_salt, default: ''
      t.string :display_name, default: ''

      t.timestamps null: false
    end
  end
end
