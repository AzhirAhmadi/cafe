class SetCoffeeShopMaintainerToNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :coffee_shops, :maintainer_id, false
  end
end
