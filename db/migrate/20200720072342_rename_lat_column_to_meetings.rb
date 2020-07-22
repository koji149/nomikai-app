class RenameLatColumnToMeetings < ActiveRecord::Migration[5.2]
  def change
    rename_column :meetings, :lat, :latitude
    rename_column :meetings, :lng, :longitude
  end
end
