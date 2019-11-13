class UpdateUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :trips, :start_date, :string
    remove_column :trips, :return_date, :string
    add_column :users, :user_name, :string
  end
end
