begin
  require File.join(File.dirname(__FILE__), 'system', 'secrets.rb')
rescue LoadError => e
end

require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'haml'
require 'json'
require 'uri'

require './models'

module WhatCrop
  class BaseApp < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    BASEDIR = File.dirname(File.expand_path(__FILE__))

    enable :sessions
    set :session_secret, 'development secret'

    configure :development do
      enable :show_exceptions, :dump_errors
      disable :raise_errors, :clean_trace
    end

    configure :test do
      enable :logging, :raise_errors, :dump_errors
    end

    configure :production do
      set :session_secret, (ENV['SESSION_SECRET'] || raise)
    end

    set :public_folder,  "#{BASEDIR}/public"
    set :static,         true
  end

  class AdminApp < BaseApp
    set :admin_password, nil

    configure :development do
      set :admin_password, 'dev'
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
      "yup, index, and #{session[:logged_in]}"
    end

    get '/login' do
      haml :admin_login
    end

    post '/login' do
      if params[:password] == settings.admin_password
        session[:logged_in] = true
        redirect to('/protected')
      else
        haml :admin_login, :locals => { :bad_password => true }
      end
    end

    get '/logout' do
      session.delete(:logged_in)
      redirect to('/')
    end

    get '/protected' do
      haml :admin_index
    end
  end

  class UserApp < BaseApp
    before do
      if gid = session[:gid]
        @game = Models::Game.where(:id => gid).first
        session.delete(:gid) unless @game
      end
    end

    get '/' do
      haml :index
    end

    post '/games' do
      game = Models::Game.create!(:max_rounds => 50)
      session[:gid] = game.id
      redirect to("/games/#{game.id}")
    end

    before '/games/:id/?*' do
      401 unless @game && @game.id == params[:id]
    end

    get '/games/:id' do
      redirect to('/game/:id/complete') if @game.complete?

      haml :game, :locals => { :game => @game }
    end

    get '/games/:id/complete' do
      redirect to("/games/#{params[:id]}") unless @game.complete?

      haml :game_complete, :locals => { :game => @game }
    end

    post '/games/:id/rounds' do
      if @game.record_round(
          :weather     => params[:weather],
          :crop_choice => params[:crop_choice],
          :score       => params[:score]
        )
        if @game.complete?
          {
            :status => 'game_complete',
            :redirect => to("/games/#{params[:id]}/complete")
          }
        else
          {
            :status => 'round_complete'
          }
        end.to_json
      else
        400
      end
    end
  end
end

if __FILE__ == $0
  WhatCrop::App.run!
end
