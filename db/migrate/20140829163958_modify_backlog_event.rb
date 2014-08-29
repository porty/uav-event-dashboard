class ModifyBacklogEvent < ActiveRecord::Migration
  def change
    rename_column :events_backlogs, :waiting,   :waiting_count
    change_column :events_backlogs, :waiting_count, :integer, null: false

    rename_column :events_backlogs, :completed, :completed_count
    change_column :events_backlogs, :completed_count, :integer, null: false

    add_column :events_backlogs, :waiting_size,   :integer, null: false
    add_column :events_backlogs, :completed_size, :integer, null: false
  end
end
