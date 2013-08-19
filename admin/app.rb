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

    before '/protected/?*' do
      unless session[:logged_in] == true
        redirect to('/')
      end
    end

    get '/' do
      if session[:logged_in] == true
        redirect to('/protected')
      else
        redirect to('/login')
      end
    end

    get '/login' do
      haml :login
    end

    post '/login' do
      if params[:password] == settings.admin_password
        session[:logged_in] = true
        redirect to('/protected')
      else
        haml :login, :locals => { :bad_password => true }
      end
    end

    get '/logout' do
      session.delete(:logged_in)
      redirect to('/')
    end

    get '/protected' do
      haml :index
    end
  end
end
