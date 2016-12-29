class AddTitleToIssue < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :title, :string
  end
end
