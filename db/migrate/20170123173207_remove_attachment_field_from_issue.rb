class RemoveAttachmentFieldFromIssue < ActiveRecord::Migration[5.0]
  def change
    remove_column :issues, :attachment
    add_reference :issues, :issue_attachment, index: true
  end
end
