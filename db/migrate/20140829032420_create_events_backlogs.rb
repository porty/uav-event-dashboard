class CreateEventsBacklogs < ActiveRecord::Migration
  def change
    create_table :events_backlogs do |t|
      t.integer :waiting
      t.integer :completed

      t.integer :event_id, null: false

      t.timestamps
    end

    add_foreign_key(:events_backlogs, :events)
  end
end
