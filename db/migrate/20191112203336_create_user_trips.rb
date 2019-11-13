class CreateUserTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :user_trips do |t|
      t.integer :user_id
      t.integer :trip_id
      t.float :exchange_rate
      t.string :home_country
      t.string :destination_country
      t.string :destination_city
    end
  end
end
