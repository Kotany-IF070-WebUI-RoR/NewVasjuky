class AddDescriptionAndTagsToCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :categories, :description, :string
    add_column :categories, :tags, :string
  end
end
