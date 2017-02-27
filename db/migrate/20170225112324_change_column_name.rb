class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :banned, :active
  end
end
