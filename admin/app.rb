module WhatCrop
  class AdminApp < BaseApp
    set :app_file, __FILE__

    set :admin_password, nil

    configure :development do
      set :admin_password, 'admin'
    end

    configure :production do
      set :admin_password, (ENV['ADMIN_PASSWORD'] || raise)
    end

    before '/*' do
      pass if ['logout', ''].include? params[:splat].first

      unless session[:logged_in] == true
        redirect to('/')
      end
    end

    get '/' do
      haml :login
    end

    post '/' do
      if params[:password] == settings.admin_password
        session[:logged_in] = true
        redirect to('/dashboard')
      else
        status 401
        haml :login, :locals => { :bad_password => true }
      end
    end

    get '/logout' do
      session.delete(:logged_in)
      redirect to('/')
    end

    get '/dashboard' do
      haml :dashboard, :locals => { :games => Models::Game.all }
    end

    get '/games/:id' do
      game = Models::Game.find(params[:id])
      haml :game, :locals => { :game => game }
    end
  end
end
