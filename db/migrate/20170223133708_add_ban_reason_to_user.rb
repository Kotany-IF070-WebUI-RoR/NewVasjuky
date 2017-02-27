class AddBanReasonToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :ban_reason, :string
  end
end
