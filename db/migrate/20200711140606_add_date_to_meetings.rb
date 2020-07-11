class AddDateToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :date, :date
    add_column :meetings, :time, :time
  end
end
