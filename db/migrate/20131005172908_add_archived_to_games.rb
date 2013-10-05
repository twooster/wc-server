class AddArchivedToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :archived, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :games, :archived
  end
end
