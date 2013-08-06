require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'haml'
require 'json'

require './models'

module WhatCrop
  class App < Sinatra::Base
    BASEDIR = File.dirname(File.expand_path(__FILE__))

    configure :development do
      set :database, 'sqlite:///var/development.db'

      enable :show_exceptions, :dump_errors
      disable :raise_errors, :clean_trace
    end

    configure :test do
      set :database, 'sqlite:///var/test.db'

      enable :logging, :raise_errors, :dump_errors
    end

    configure :production do
      set :database, 'sqlite:///var/production.db'
    end

    enable :sessions
    set :session_secret, 'seekret seekret'

    set :public_folder,  "#{BASEDIR}/public"
    set :static,         true

=begin
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => settings.database
    )
=end

    before do
      if gid = session[:gid]
        @game = Models::Game.where(id: gid).first
        session.delete(:gid) unless @game
      end
    end

    get '/' do
      haml :index
    end

    post '/games' do
      game = Models::Game.create!
      session[:gid] = game.id
      redirect to("/games/#{game.id}")
    end

    before '/games/:id/?*' do
      401 unless @game && @game.id == params[:id]
    end

    get '/games/:id' do
      redirect to('/game/:id/complete') if @game.complete?

      haml :game, locals: { game: @game }
    end

    get '/games/:id/complete' do
      redirect to("/games/#{params[:id]}") unless @game.complete?

      render :game_complete, locals: { game: @game }
    end

    post '/games/:id/rounds' do
      if @game.record_round(params.delete(:id))
        if @game.complete?
          {
            status: 'game_complete',
            redirect: to("/games/#{params[:id]}/complete")
          }.to_json
        else
          {
            status: 'round_complete'
          }
        end
      else
        400
      end
    end
  end
end

if __FILE__ == $0
  WhatCrop::App.run!
end
