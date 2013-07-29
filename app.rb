require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'

require './config'
require './models'

get '/' do
  'Nothing here'
end
