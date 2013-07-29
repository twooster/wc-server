class CreateGames < ActiveRecord::Migration
  def up
    create_table :games do |t|
      t.integer :user_id, null: false
      t.timestamps
    end
  end

  def down
    drop_table :games
  end
end
