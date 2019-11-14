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
        puts "Username already exists. Please enter another name:"
        input = gets.chomp # if fail, try STDIN.gets.chomp
        existing_user = User.find_by(user_name: input)
    end
    
    puts "Please enter the three-letter abbreviation for your home country's currency (e.g. USD, EUR, JPY, VND, CNY):"
    currency = gets.chomp
    puts "You've entered #{currency}.\n
    "
    
    $new_user = User.create(first_name: first_name, last_name: last_name, user_name: input, home_currency: currency)
    $userid = $new_user.id
    UserTrip.create(user_id: $userid)
    puts "Welcome #{first_name} #{last_name}! Your username is #{input}. Your home currency is set to #{currency}.\n
    "
    user_options
end

def log_in
    puts "Please type in your username:"
    input = gets.chomp
    while !User.find_by(user_name: input)
        puts "Username does not exist. Please try harder!"
        input = gets.chomp
    end
    $username = input
    puts "Welcome, #{$username}!\n
    "
    $userid = User.find_by(user_name: $username).id
    $home_currency = User.find_by(id: $userid).home_currency
    user_options

end

def user_options
    puts "What do you want from me!!!!!!
    -> you can 'add'/'delete' destination currencies (add / delete),
    -> get exchange rate(s) between home currency and all foreign currencies (get rate),
    -> get exact amount in foreign currency (get amount)
    -> or 'log out' (log out)\n
    "
    input = gets.chomp
    while input != 'add' && input != 'delete' && input != 'get rate' && input != 'get amount' && input != 'log out'
        puts "Please choose from the following options!!!!!!!!!!!!!!!!!!!
        -> you can 'add'/'delete' destination currencies (add / delete),
        -> get exchange rate(s) between home currency and all foreign currencies (get rate),
        -> get exact amount in foreign currency (get amount)
        -> or 'log out' (log out)\n
        "
        input = gets.chomp
    end
    if input == 'add'
        add_currency
    elsif input == 'delete'
        delete_currency
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
    new_trip = Trip.create(destination_currency: input)
    new_trip_id = new_trip.id
    user_trip = UserTrip.find_by(user_id: $userid)
    user_trip.trip_id == nil ? user_trip.update(trip_id: new_trip_id) : UserTrip.create(user_id: $userid, trip_id: new_trip_id)
    puts "You've entered #{input}.\n\n"
    user_options
end

def delete_currency
    puts "Please enter the three-letter abbreviation for the currency you want to delete (e.g. USD, EUR, JPY, VND, CNY):"
    input = gets.chomp
    user = User.find($userid)
    trips = user.trips
    target = trips.find_by(destination_currency: input)
    tripid = target.id
    Trip.destroy_by(id: tripid)
    UserTrip.destroy_by(trip_id: tripid)
    puts "You have successfully deleted #{input} from your destination currencies.\n\n"
end

def get_rate
    user = User.find($userid)
    trips = user.trips
    hash = {}
    trips.each{|trip| hash[trip.destination_currency] = get_current_rate(user.home_currency, trip.destination_currency)}
    hash.each{|currency, rate| puts "For #{currency}, the current exchange rate is #{rate}."}
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
end

def log_out
    signup_or_login
end

signup_or_login