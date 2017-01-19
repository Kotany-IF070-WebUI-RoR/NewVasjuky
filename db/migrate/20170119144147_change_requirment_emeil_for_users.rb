class ChangeRequirmentEmeilForUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :email, :string, null: true, default: ''
  end
end
