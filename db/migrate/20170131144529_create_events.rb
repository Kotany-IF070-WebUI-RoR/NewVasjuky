class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :issue_id
      t.integer :before_status
      t.integer :after_status

      t.timestamps
    end
  end
end
