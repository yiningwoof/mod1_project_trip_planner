require_relative 'config/environment.rb'
# require 'sinatra'

# configure :development do
#     set :database_file, 'db/trips.sqlite'
# end
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
 ActiveRecord::Base.logger = Logger.new(STDOUT)
 Pry.start
end

# task :environment do
#     require_relative 'environment'
# end