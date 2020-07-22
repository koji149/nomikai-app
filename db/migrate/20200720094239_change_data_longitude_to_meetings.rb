class ChangeDataLongitudeToMeetings < ActiveRecord::Migration[5.2]
  def change
    change_column :meetings, :latitude, :decimal, precision: 11, scale: 8
    change_column :meetings, :longitude, :decimal, precision: 11, scale: 8
  end
end
