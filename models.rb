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
          unless complete?
            prev_round = last_round || 0
            game_over  = attrs.delete(:game_over)

            rounds.create!(attrs) do |round|
              round.round_number = prev_round
            end

            update_attributes!(:last_round => prev_round + 1,
                               :complete   => game_over)
            self
          end
        end
      end
    end

    class Round < ActiveRecord::Base
      belongs_to :game

      alias_attribute :played_at, :created_at
    end
  end
end
