class ChangeCoffeeShopIdToCreatorId < ActiveRecord::Migration[5.2]
  def change
    rename_column :board_games, :coffee_shop_id, :creator_id
 end
end
