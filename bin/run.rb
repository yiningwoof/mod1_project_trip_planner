require_relative '../config/environment.rb'
require_relative './api.rb'

def logo
    puts "
     _....._
    ';-.--';'
      }===={       _.---.._
    .'  _|_ '.    ';-..--';
   /:: (_|_`  \    `}===={
  |::  ,_|_)   |  .:  _|_ '.
  |::.   |     /_;:_ (_|_`  \\
   '::_     _-;'--.-';_|_)   |
       `````  }====={  |     /
            .'  _|_  '.   _.'
           /:: (_|_`   \``
          |::  ,_|_)    |
          \\\::.   |      /
           '::_      _.'
               ``````  
    "

end

def wave
    puts "
    .-.  _
    | | / )
    | |/ /
   _|__ /_
  / __)-' )
  \\  `(.-')
   > ._>-'
  / \\/
    "
end

def frustration
    puts "
     ____________________
    /                    \\
    |     In case of     |
    |     Frustration    |
    \\____________________/
             !  !
             !  !
             L_ !
            / _)!
           / /__L
     _____/ (____)
            (____)
     _____  (____)
          \\_(____)
             !  !
             !  !
             \\__/ 
             \n"
end

def signup_or_login
    logo
    puts "Welcome to the EXCHANGE RATE FINDER! Please sign up or log in (sign up / log in):"
    input = gets.chomp
    while input != 'sign up' && input != 'log in'
        puts "Please type 'sign up' or 'log in'"
        input = gets.chomp
    end
    if input == 'sign up'
        sign_up
    elsif input == 'log in'
        log_in
    end
end

def sign_up
    puts "Please enter your first name:"
    first_name = gets.chomp
    
    puts "Please enter your last name:"
    last_name = gets.chomp
    
    puts "Please choose a username:"
    input = gets.chomp
    existing_user = User.find_by(user_name: input)
    while existing_user
        frustration
        puts "\n"
        puts "Username already exists. Please enter another name:"
        input = gets.chomp # if fail, try STDIN.gets.chomp
        existing_user = User.find_by(user_name: input)
    end
    
    puts "Please enter the three-letter abbreviation for your home country's currency (e.g. USD, EUR, JPY, VND, CNY):"
    $home_currency = gets.chomp
    puts "You've entered #{$home_currency}.\n
    "
    
    $new_user = User.create(first_name: first_name, last_name: last_name, user_name: input, home_currency: $home_currency)
    $userid = $new_user.id
    puts "Welcome #{first_name} #{last_name}! Your username is #{input}. Your home currency is set to #{$home_currency}.\n
    "
    wave
    user_options
end

def log_in
    puts "Please type in your username:"
    input = gets.chomp
    while !User.find_by(user_name: input)
        frustration
        puts "\n"
        puts "Username does not exist. Please try harder!"
        input = gets.chomp
    end
    $username = input
    puts "Welcome, #{$username}!\n
    "
    wave
    $userid = User.find_by(user_name: $username).id
    $home_currency = User.find_by(id: $userid).home_currency
    user_options

end

def user_options
    puts "Please choose from the following options:
    -> (add / delete) destination currencies,
    -> (join) an existing user's trip,
    -> (add friend) to your trip,
    -> (get rate) between home currency and all foreign currencies,
    -> (get amount) in foreign currency,
    -> (log out)\n
    "
    input = gets.chomp
    while input != 'add' && input != 'delete' && input != 'join' && input != "add friend" && input != 'get rate' && input != 'get amount' && input != 'log out'
        frustration
        puts "\n"
        puts "Invalid response. PLEASE CHOOSE FROM THE FOLLOWING OPTIONS!!!
        -> (add / delete) destination currencies,
        -> (join) an existing user's trip,
        -> (add friend) to your trip,
        -> (get rate) between home currency and all foreign currencies,
        -> (get amount) in foreign currency,
        -> (log out)\n
        "
        input = gets.chomp
    end
    if input == 'add'
        add_currency
    elsif input == 'delete'
        delete_currency
    elsif input == 'join'
        join_trip
    elsif input == 'add friend'
        add_friend
    elsif input == 'get rate'
        get_rate
    elsif input == 'get amount'
        get_amount
    elsif input == 'log out'
        log_out
    end
end

def add_currency
    puts "Please enter the three-letter abbreviation for your destination country's currency (e.g. USD, EUR, JPY, VND, CNY):"
    input = gets.chomp
    user = User.find($userid)
    trips = user.trips
    destination_arr = trips.map {|trip| trip.destination_currency }
    while destination_arr.include?(input)
        frustration
        puts "\n"
        puts "You have already entered this currency. Please try again."
        input = gets.chomp
    end
    new_trip = Trip.create(destination_currency: input)
    trips << new_trip
    puts "You've successfully added #{input}.\n\n"
    wave
    user_options
end

def delete_currency
    user = User.find($userid)
    trips = user.trips
    if trips.length == 0
        frustration
        puts "\n"
        puts "You have nothing to delete yet. Please add currency first!
        \n\n"
        add_currency
    else
        puts "You have the following to delete from:"
        trips.each{|trip| puts trip.destination_currency}
        puts "Please type in the three-letter code to delete:"
        input = gets.chomp
        user = User.find($userid)
        target = trips.find_by(destination_currency: input)
        tripid = target.id
        Trip.destroy_by(id: tripid)
        UserTrip.destroy_by(trip_id: tripid)
        puts "You've successfully deleted #{input}.\n\n"
        wave
        user_options
    end
end

def join_trip
    puts "To join an existing user's trip, type in their username:"
    primary_username = gets.chomp
    primary_user = User.find_by(user_name: primary_username)
    current_user = User.find($userid)
    primary_userid = primary_user.id
    while primary_userid == nil
        frustration
        puts "\n"
        puts "The user does not exist. Please try again."
        primary_username = gets.chomp
    end
    puts "Your friend's trips involve these currency(s):"
    primary_user.trips.each{|trip| puts trip.destination_currency}
    puts "Which one you want to join?"
    currency = gets.chomp
    target_trip = primary_user.trips.find_by(destination_currency: currency)
    # target_trip_id = target_trip.id
    current_user.trips << target_trip
    puts "You have successfully joined #{primary_username}'s trip with #{currency} as your destination currency.'"
end

def add_friend
    puts "To add an existing user to your trip, please type their username:"
    friend_username = gets.chomp
    friend = User.find_by(user_name: friend_username)
    current_user = User.find($userid)
    friend_userid = friend.id
    while friend_userid == nil
        frustration
        puts "\n"
        puts "The user does not exist. Please try again."
        friend_userid = gets.chomp
    end
    puts "Here is a list of your currency(s):
    \n"
    current_user.trips.each{|trip| puts trip.destination_currency}
    puts "Please select a currency:
    \n"
    currency = gets.chomp
    target_trip = current_user.trips.find_by(destination_currency: currency)
    # target_trip_id = target_trip.id
    friend.trips << target_trip
    puts "You have successfully added #{friend_username}."
end

def get_rate
    user = User.find($userid)
    # Check if trips is an empty hash; if empty, tell user to add a currency. Else, do the thing

    if user.trips.length.zero?
        puts "Please enter the three-letter abbreviation for your destination country's currency (e.g. USD, EUR, JPY, VND, CNY):"
        input = gets.chomp
        trips = user.trips
        trips << Trip.create(destination_currency: input);
        puts trips.length
        puts user.trips.length
        user.reload
        puts user.trips.length
        # <<(Trip.create(destination_currency: input))
        # Adds one or more objects to the collection by setting their foreign keys to the collection’s primary key. Note that this operation instantly fires update SQL without waiting for the save or update call on the parent object, unless the parent object is a new record. This will also run validations and callbacks of associated object(s).
        # HARD CODE
        # new_trip_id = new_trip.id
        # # new_user_trip = UserTrip.create(user_id: $userid, trip_id: new_trip_id)
        # user_trips = UserTrip.find_by(user_id: $userid)
        # user_trips.each{|user_trip|
        # user_trip.trip_id == nil ? user_trip.update(trip_id: new_trip_id) : UserTrip.create(user_id: $userid, trip_id: new_trip_id)
        # }
        puts "You've successfully added #{input}.\n\n"
        wave
    end
    hash = {}
    user.trips.each{|trip| hash[trip.destination_currency] = get_current_rate(user.home_currency, trip.destination_currency)}
    hash.each{|currency, rate| puts "For #{currency}, the current exchange rate is 1 #{$home_currency} = #{rate} #{currency}.\n\n"}
    wave
    user_options
end

def get_amount
    puts "You have (e.g. USD, EUR, JPY, VND, CNY):"
    from = gets.chomp
    puts "You want (e.g. USD, EUR, JPY, VND, CNY):"
    to = gets.chomp
    puts "How much #{from} would you like to convert?"
    amount = gets.chomp
    result = get_destination_cash_amount(from, to, amount)
    puts "#{amount} #{from} is worth #{result} in #{to}."
    wave
    user_options
end

def log_out
    puts "Thanks for using me. See you next time!
    \n\n"
    wave
    puts "==========================================================================================="
    signup_or_login
end

ActiveRecord::Base.logger = Logger.new(STDOUT)

# signup_or_login
# user_id = 17
# destination_currency = 'JPY'
# test = UserTrip.joins(:trip).where(user_id: user_id, trips: {destination_currency: destination_currency})
# puts test

# ActiveRecord::Base.connection.execute("BEGIN TRANSACTION; END;")

signup_or_login