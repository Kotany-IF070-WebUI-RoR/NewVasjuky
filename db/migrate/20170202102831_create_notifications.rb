class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :event_id
      t.boolean :readed, default: false

      t.timestamps
    end

    add_index :notifications, [:user_id, :event_id, :readed]
  end
end
