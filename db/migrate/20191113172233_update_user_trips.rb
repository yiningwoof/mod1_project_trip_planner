class UpdateUserTrips < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_trips, :destination_currency, :string
    remove_column :user_trips, :home_currency, :string
  end
end
