class ChangeCreatorIdToCoffeeShopId < ActiveRecord::Migration[5.2]
  def change
    rename_column :board_games, :creator_id, :coffee_shop_id
  end
end
