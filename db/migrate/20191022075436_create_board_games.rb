class CreateBoardGames < ActiveRecord::Migration[5.2]
  def change
    create_table :board_games do |t|
      t.string :name, null: false
      t.string :publisher, null: false
      t.integer :min_player, null: false
      t.integer :max_player, null: false
      t.integer :play_time, null: false
      t.text :description
      t.datetime :deleted_at
      
      t.references :coffee_shop, foreign_key: { to_table: 'coffee_shops' }

      t.timestamps
    end
  end
end
