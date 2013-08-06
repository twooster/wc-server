class CreateGames < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.integer :max_rounds, null: false
      t.integer :last_round, null: false

      t.timestamps
    end
  end

  def down
    drop_table :games
  end
end
