class CreateTables < ActiveRecord::Migration[5.2]
  def change
    create_table :tables do |t|
      t.string :capacity, null: false
      t.string :table_number, null: false
      t.datetime :deleted_at

      t.references :event, foreign_key: { to_table: 'events' }
      t.references :board_game, foreign_key: { to_table: 'board_games' }

      t.timestamps
    end
  end
end
