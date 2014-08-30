class CreateEventsTransfers < ActiveRecord::Migration
  def change
    create_table :events_transfers do |t|
      t.string  :name,     null: false, :limit => 20
      t.integer :size,     null: false
      t.integer :duration, null: false

      t.integer :event_id, null: false

      t.timestamps
    end

    add_foreign_key(:events_transfers, :events)
  end
end
