class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :issue_id
      t.string :before_state
      t.string :after_state

      t.timestamps
    end
  end
end
