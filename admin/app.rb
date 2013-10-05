require 'csv'

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
        redirect to('/games')
      else
        status 401
        haml :login, :locals => { :bad_password => true }
      end
    end

    get '/logout' do
      session.delete(:logged_in)
      redirect to('/')
    end

    get '/games' do
      filter = (params[:filter] || 'all').downcase

      games = Models::Game.where(:archived => filter == 'archived')

      case filter
      when 'complete'
        games = games.where(:complete => true)
      when 'not-empty'
        games = games.where('last_round IS NOT NULL')
      end

      haml :games, :locals => {
        :games => games,
        :filter => params[:filter]
      }
    end

    post '/games/csv' do
      content_type 'text/csv'

      filename = "games-#{Time.now.strftime('%y%m%d-%H%M')}.csv"
      headers \
        'Content-Disposition' => "inline; filename=\"#{filename}\""

      return '' unless params[:games]
      games = Models::Game.where(:id => params[:games])

      # REST this is not
      games.update_all(:archived => true) if params[:archive]

      stream do |out|
        games.each do |game|
          out << generate_game_csv(game)
        end
      end
    end

    get '/games/:id' do
      game = Models::Game.find(params[:id])
      haml :game, :locals => { :game => game }
    end

    post '/games/:id' do
      game = Models::Game.find(params[:id])

      game.update_attribute(:archived, !!params[:archived])
      redirect to("/games/#{params[:id]}")
    end

    get '/games/:id/csv' do
      content_type 'text/csv'

      game = Models::Game.find(params[:id])

      filename = "game-#{game.id}-#{Time.now.strftime('%y%m%d-%H%M')}.csv"
      headers \
        'Content-Disposition' => "inline; filename=\"#{filename}\""

      generate_game_csv(game)
    end

    def generate_game_csv(game)
      buf = []
      cum_score = 0
      last_time = game.created_at
      game.rounds.each do |round|
        cum_score += round.score
        buf << CSV.generate_line([
          game.id,
          game.label,
          round.round_number,
          round.crop_choice,
          round.weather,
          round.created_at - last_time,
          cum_score,
          round.score
        ])
        last_time = round.created_at
      end
      buf << ''
      buf.join("\n")
    end
  end
end
