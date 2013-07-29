require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'haml'

require './config'
require './helpers'
require './models'

before do
  @flash = session['flash'] || {}
  session.delete 'flash'
end

get '/' do
  haml :index
end

get '/login' do
  haml :'admin/login'
end

post '/login' do
  unless params[:password] == 'seekret'
    flash :error, 'Permission denied'
    haml :'admin/login'
  else
    session['admin'] = true
    redirect to('/admin')
  end
end

get '/logout' do
  session.delete 'admin'
  session.delete 'uid'
  redirect to('/')
end

before %r{/admin(/.*)?} do
  unless session['admin'] == true
    flash :error, 'Permission denied'
    redirect to('/login')
  end
end

get '/admin' do
  haml :'admin/index'
end
