class UpdateColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :home_country, :home_currency
    rename_column :user_trips, :home_country, :home_currency
    rename_column :trips, :destination_country, :destination_currency
    rename_column :user_trips, :destination_country, :destination_currency
    remove_column :trips, :destination_city, :string
    remove_column :user_trips, :destination_city, :string
  end
end
