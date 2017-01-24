class AddPostedFacebookToIssue < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :posted_on_facebook, :boolean, default: false
  end
end
