module WhatCrop
  class UserApp < BaseApp
    # Views, etc, relative from the location of this file
    set :app_file, __FILE__

    before do
      if gid = session[:gid]
        @game = Models::Game.where(:id => gid).first
        session.delete(:gid) unless @game
      end
    end

    get '/' do
      'Nothing here'
    end

    post '/games' do
      game = Models::Game.create!(:label => params[:label].strip)
      session[:gid] = game.id
      { :id => game.id }.to_json
    end

    before '/games/:id/?*' do
      halt 401 unless @game && @game.id == params[:id].to_i
    end

    post '/games/:id/rounds' do
      if @game.record_round(
          :game_over   => params[:game_over],
          :weather     => params[:weather],
          :crop_choice => params[:crop_choice],
          :score       => params[:score]
        )
        200
      else
        400
      end
    end
  end
end
