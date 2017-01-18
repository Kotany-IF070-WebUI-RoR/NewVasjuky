class RemoveApprovedNameFromIssues < ActiveRecord::Migration[5.0]
  def up
    remove_column :issues, :approved
  end

  def down
    add_column :issues, :approved, :boolean, default: false
  end
end
