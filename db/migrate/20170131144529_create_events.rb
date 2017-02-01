class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :issue_id, null: true
      t.integer :before_status, null: true
      t.integer :after_status, null: true

      t.timestamps
    end

    add_index :events, :issue_id
  end
end
