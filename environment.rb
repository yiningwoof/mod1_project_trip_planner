require 'rake'
require 'active_record'
require 'yaml/store'
require 'ostruct'
require 'date'
require 'require_all'
# require 'pry'

require 'bundler/setup'
Bundler.require_all
 
# put the code to connect to the database here
ActiveRecord::Base.establish_connection(
:adapter => "sqlite3",
:database => "db/trips.sqlite"
)

require_all 'lib'
# require_all 'db'