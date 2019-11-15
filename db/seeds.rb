User.destroy_all
Trip.destroy_all
UserTrip.destroy_all

heidi = User.create(first_name: 'Heidi', last_name: 'Boulter', user_name: 'hb1', home_currency: 'USD')
vnm_trip = Trip.create(destination_currency: 'VND')
heidi_vnm = UserTrip.create(user: heidi, trip: vnm_trip)