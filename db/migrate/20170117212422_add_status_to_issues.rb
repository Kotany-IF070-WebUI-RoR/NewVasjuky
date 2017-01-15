class AddStatusToIssues < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :status, :integer, default: 0
  end
end
