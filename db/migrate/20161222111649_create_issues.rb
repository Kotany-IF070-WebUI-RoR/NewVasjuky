class CreateIssues < ActiveRecord::Migration[5.0]
  def change
    create_table :issues do |t|
      # Form fields
      t.string :name, default: ''
      t.string :address, default: ''
      t.string :phone, default: ''
      t.string :email, default: ''
      t.string :category
      t.string :description, default: ''
      t.string :attachment
      # Moderated?
      t.boolean :approved, default: false
      t.timestamps
    end
  end
end
