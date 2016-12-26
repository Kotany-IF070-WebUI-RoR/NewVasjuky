class AddReporterIdToIssue < ActiveRecord::Migration[5.0]
  def change
    add_reference :issues, :user, index: true
  end
end
