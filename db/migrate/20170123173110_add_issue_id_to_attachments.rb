class AddIssueIdToAttachments < ActiveRecord::Migration[5.0]
  def change
    add_reference :issue_attachments, :issue, index: true
  end
end
