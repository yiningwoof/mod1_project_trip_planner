class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.string :destination_city
      t.string :destination_country
      t.string :start_date
      t.string :return_date
    end
  end
end
