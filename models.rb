module WhatCrop
  module Models
    class Game < ActiveRecord::Base
      has_many :rounds

      scope :complete, ->() {
        where('last_round = max_rounds')
      }

      def complete?
        last_round == max_rounds
      end

      def record_round(attrs = {})
        return nil if complete?
        with_lock do
          reload
          unless complete?
            rounds.create!(attrs) do |round|
              round.round_number = last_round
            end
            update_attributes!(last_round: last_round+1)
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
