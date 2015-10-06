class CreateMoodDayEmotions < ActiveRecord::Migration
  def change
    create_table :mood_day_emotions do |t|
      t.integer :mood_day_id
      t.integer :emotion_id
      t.float :percentage

      t.timestamps null: false
    end
  end
end
