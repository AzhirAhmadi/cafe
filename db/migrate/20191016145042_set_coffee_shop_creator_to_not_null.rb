class SetCoffeeShopCreatorToNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :coffee_shops, :creator_id, false
  end
end
