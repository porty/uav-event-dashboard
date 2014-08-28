class RenameTypeColumnAndAddIndex < ActiveRecord::Migration
  def change
    rename_column :events, :type, :event_type
    add_index :events, :event_type
  end
end
