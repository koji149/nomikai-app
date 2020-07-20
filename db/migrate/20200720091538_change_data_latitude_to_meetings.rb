class ChangeDataLatitudeToMeetings < ActiveRecord::Migration[5.2]
  def change
    change_column :meetings, :latitude, :float
    change_column :meetings, :longitude, :float
  end
end
