class CreateEventTransmissions < ActiveRecord::Migration
  def change
    create_table :event_transmissions do |t|
      t.integer :timestamp, null: false

      t.timestamps
    end
  end
end
