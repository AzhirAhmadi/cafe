class SetCoffeeShopOwnerIdToNotNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :coffee_shops, :owner_id, false
  end
end
