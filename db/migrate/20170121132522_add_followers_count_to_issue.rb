class AddFollowersCountToIssue < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :followers_count, :integer, default: 0
  end
end
