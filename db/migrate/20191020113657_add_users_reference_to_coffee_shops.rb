class AddUsersReferenceToCoffeeShops < ActiveRecord::Migration[5.2]
  def change
    add_reference :coffee_shops, :maintainer, foreign_key: { to_table: 'users' }
  end
end
