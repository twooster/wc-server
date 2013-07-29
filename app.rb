require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'

require './config'

get '/' do
  'Nothing here'
end
