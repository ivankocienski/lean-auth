class AddAnalysedFlagToLogEntries < ActiveRecord::Migration
  def change
    add_column :log_entries, :analyzed, :boolean, default: false
  end
end
