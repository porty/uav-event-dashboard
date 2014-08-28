class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string  :type,      null: false, limit: 20
      t.integer :timestamp, null: false
      t.string  :data,      null: false

      t.integer :event_transmission_id, :null => false

      t.timestamps
    end

    add_foreign_key(:events, :event_transmissions)
  end
end
