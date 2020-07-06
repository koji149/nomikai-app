class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :gender, :string
    add_column :users, :university, :string
    add_column :users, :comment, :text
    add_column :users, :twitter, :string
    add_column :users, :instagram, :string
    add_column :users, :other_link, :string
  end
end
