require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'haml'

require './config'
require './models'

get '/' do
  haml :index
end
