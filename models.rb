module WhatCrop
  module Models
    class Game < ActiveRecord::Base
      has_many :rounds

      def score
        rounds.sum(&:score)
      end

      def record_round(attrs = {})
        with_lock do
          reload
          return false if complete?

          round_num  = (last_round || -1) + 1
          game_over  = attrs.delete(:game_over) || false

          last_round = rounds.order('round_number DESC').first
          last_round_at = last_round && last_round.created_at || created_at

          rounds.create!(attrs) do |round|
            round.round_number  = round_num
            round.seconds_taken = (Time.now - last_round_at).to_i
          end

          update_attributes!(:last_round => round_num,
                             :complete   => game_over)
          self
        end
      end
    end

    class Round < ActiveRecord::Base
      belongs_to :game

      alias_attribute :played_at, :created_at
    end
  end
end
