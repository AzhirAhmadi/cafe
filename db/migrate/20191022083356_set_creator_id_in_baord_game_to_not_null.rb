class SetCreatorIdInBaordGameToNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :board_games, :creator_id, false
  end
end
