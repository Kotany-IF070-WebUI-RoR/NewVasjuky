class ChangeActiveDefaultValue < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:users, :active, true)
  end
end
