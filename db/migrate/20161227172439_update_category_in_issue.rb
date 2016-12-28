class UpdateCategoryInIssue < ActiveRecord::Migration[5.0]
  def change
  	remove_column :issues, :category, :integer
  	add_column :issues, :category_id, :integer
  	add_index :issues, :category_id
  end
end
