class CreateIssueAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :issue_attachments do |t|
      t.string :attachment
      t.timestamps
    end
  end
end
