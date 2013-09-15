class AddSecondsTakenToRounds < ActiveRecord::Migration
  def self.up
    add_column    :rounds, :seconds_taken, :integer, :null => false, :default => 0
    # Silly databases
    change_column :rounds, :seconds_taken, :integer, :null => false
  end

  def self.down
    remove_column :rounds, :seconds_taken
  end
end
