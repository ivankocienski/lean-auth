class CreateMoodDays < ActiveRecord::Migration
  def change
    create_table :mood_days do |t|
      t.integer :user_id
      t.date :day_in_time

      t.timestamps null: false
    end
  end
end
