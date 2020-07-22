class CreateMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :meetings do |t|
      t.integer :user_id
      t.integer :area
      t.datetime :date_time
      t.string :bar
      t.string :url
      t.text :explain

      t.timestamps
    end
  end
end
