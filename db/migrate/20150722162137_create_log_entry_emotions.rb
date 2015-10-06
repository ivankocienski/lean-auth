class CreateLogEntryEmotions < ActiveRecord::Migration
  def change
    create_table :log_entry_emotions do |t|
      t.integer :log_entry_id
      t.integer :emotion_id
      t.float :percentage
      t.integer :count

      t.timestamps null: false
    end
  end
end
