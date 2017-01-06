class AddLatitudeAndLongitudeAndLocationToIssue < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :latitude, :decimal
    add_column :issues, :longitude, :decimal
    add_column :issues, :location, :string
  end
end
