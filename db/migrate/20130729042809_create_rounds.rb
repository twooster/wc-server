class CreateRounds < ActiveRecord::Migration
  def up
    create_table :rounds do |t|
      t.integer :game_id, :null => false
      t.integer :round_number, :null => false
      t.string :weather, :null => false
      t.string :crop_choice, :null => false

      t.datetime :created_at # -- played at timestamp
    end

    add_index :rounds, [:game_id, :round_number], :unique => true
  end

  def down
    drop_table :rounds
  end
end
