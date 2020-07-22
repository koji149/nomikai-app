class RemoveDatetimeFromMeetings < ActiveRecord::Migration[5.2]
  def change
    remove_column :meetings, :date_time, :datetime
  end
end
