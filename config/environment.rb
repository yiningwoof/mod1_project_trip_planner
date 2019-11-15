require 'rake'
require 'active_record'
require 'yaml/store'
require 'rest-client'
require 'json'
require 'pry'
require 'bundler'
require 'require_all'
Bundler.require # has to be .require not .require_all otherwise raise other saying development environment not set-up...
 
# put the code to connect to the database here
ActiveRecord::Base.establish_connection(
:adapter => "sqlite3",
:database => "db/trips.sqlite"
)

require_all 'lib'