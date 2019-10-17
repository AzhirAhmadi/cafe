class CreateCoffeeShops < ActiveRecord::Migration[5.2]
  def change
    create_table :coffee_shops do |t|
      t.string :name, null: false
      t.string :address, null: false

      t.references :owner, foreign_key: { to_table: 'users' }
      t.references :creator, foreign_key: { to_table: 'users' }

      t.timestamps
    end
  end
end
