class ChangeColumnToMeeting < ActiveRecord::Migration[5.2]
  def change
    change_column :meetings, :user_id, :string

  end
end
