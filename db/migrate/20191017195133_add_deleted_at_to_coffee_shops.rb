class AddDeletedAtToCoffeeShops < ActiveRecord::Migration[5.2]
  def change
    add_column :coffee_shops, :deleted_at, :datetime
  end
end
