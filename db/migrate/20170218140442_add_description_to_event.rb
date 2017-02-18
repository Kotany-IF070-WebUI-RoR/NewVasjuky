class AddDescriptionToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :description, :text
    add_column :events, :attachment, :string
  end
end
