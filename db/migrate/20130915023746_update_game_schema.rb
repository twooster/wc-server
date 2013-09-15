class UpdateGameSchema < ActiveRecord::Migration
  def self.up
    remove_column :games, :max_rounds
    add_column    :games, :complete, :boolean, :default => false
    add_column    :games, :label, :string, :null => false, :default => ''

    # Silly databases
    change_column :games, :label, :string, :null => false
  end

  def self.down
    remove_column :games, :label
    remove_column :games, :complete
    add_column    :games, :max_rounds, :integer, :null => false
  end
end
