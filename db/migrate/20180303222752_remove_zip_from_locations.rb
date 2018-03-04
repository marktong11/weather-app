class RemoveZipFromLocations < ActiveRecord::Migration[5.1]
  def change
  	remove_column :locations, :zip, :string
  end
end
