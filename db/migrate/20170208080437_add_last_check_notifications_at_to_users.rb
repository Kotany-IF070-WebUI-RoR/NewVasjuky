class AddLastCheckNotificationsAtToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_check_notifications_at, :datetime, default: DateTime.now
  end
end
