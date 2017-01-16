class RemoveAttachmentFieldFromIssue < ActiveRecord::Migration[5.0]
  def change
    remove_column :issues, :attachment
  end
end
