class User < ActiveRecord::Base
  has_many :games
  has_many :rounds, through: :game
end

class Game < ActiveRecord::Base
  belongs_to :user
  has_many :rounds
end

class Round < ActiveRecord::Base
  belongs_to :game

  alias_attribute :played_at, :created_at
end
