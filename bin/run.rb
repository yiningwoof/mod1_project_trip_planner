require 'pry'
require_relative '../environment.rb'

def welcome
    puts "$$$$$$$$$$$$$$$$$$$$"
end

def user_info
    puts "Please enter your first name:"
    first_name = STDIN.gets.chomp
    
    puts "Please enter your last name:"
    last_name = STDIN.gets.chomp
    
    puts "Please choose a username:"
    input = STDIN.gets.chomp
    existing_user = User.find_by(user_name: input)
    while existing_user
        puts "Username already exists. Please enter another name:"
        input = STDIN.gets.chomp # if fail, try STDIN.gets.chomp
        existing_user = User.find_by(user_name: input)
    end
    
    puts "Please enter the three-letter abbreviation for your home country's currency (e.g. USD, EUR, JPY, VND, CNY):"
    currency = STDIN.gets.chomp
    puts "You've entered #{currency}."
    
    User.create(first_name: first_name, last_name: last_name, user_name: input, home_currency: currency)
    puts "Welcome #{first_name} #{last_name}! Your username is #{input}. Your home currency is set to #{currency}."
end

# -------------------------

def sign_up
   user_info
end

sign_up