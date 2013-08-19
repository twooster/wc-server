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
