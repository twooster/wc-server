class MigrateScoreToFloatingPoint < ActiveRecord::Migration
  def self.up
    change_column :rounds, :score, :float, :null => false, :default => 0.0
  end

  def self.down
    change_column :rounds, :score, :integer, :null => false, :default => 0
  end
end
