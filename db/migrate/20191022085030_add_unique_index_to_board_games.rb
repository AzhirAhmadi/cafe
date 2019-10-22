class AddUniqueIndexToBoardGames < ActiveRecord::Migration[5.2]
  def change
      add_index :board_games, [:name, :creator_id], unique: true
  end
end
