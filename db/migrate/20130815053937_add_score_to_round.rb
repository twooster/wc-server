class AddScoreToRound < ActiveRecord::Migration
  def self.up
    add_column :rounds, :score, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :rounds, :score
  end
end
