class UpdateTrips < ActiveRecord::Migration[5.2]
  def change
    remove_column :trips, :start_date, :string
    remove_column :trips, :return_date, :string
  end
end
