require_relative '../config/environment.rb'

API_KEY = "c6V5BcdBVaFwG28YSnwkSfjM"
home_currency = 'USD'
destination_currency = 'CNY'
BASE_URL = "https://web-services.oanda.com/rates/api/v2/rates/spot.json?api_key=#{API_KEY}"

def get_current_rate(home_currency, destination_currency)
    params = "&base=#{home_currency}&quote=#{destination_currency}"
    url = BASE_URL + params
    response = RestClient.get(url)
    parsed_response = JSON(response)
    rate = parsed_response["quotes"][0]["midpoint"].to_f
    rate
end 

def get_destination_cash_amount(home_currency, destination_currency, home_cash_amount)
    rate = get_current_rate(home_currency, destination_currency)
    destination_cash_amount = (home_cash_amount.to_f * rate).round(2)
    puts destination_cash_amount
    destination_cash_amount
end


# get_current_rate(home_currency, destination_currency)
# get_destination_cash_amount(home_currency, destination_currency, 1000000000000)