class UpdateUserTrips2 < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_trips, :exchange_rate, :float
  end
end
