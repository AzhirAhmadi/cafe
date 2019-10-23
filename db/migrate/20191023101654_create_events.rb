class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.datetime :deleted_at
      t.references :coffee_shop, foreign_key: { to_table: 'coffee_shops' }
      t.timestamps

      t.datetime :opens_at, null: false

      t.datetime :enrol_start_time, null: false
      t.datetime :enrol_end_time, null: false

      t.datetime :event_start_time, null: false
      t.datetime :event_end_time, null: false
      
      t.datetime :closed_at, null: false
    end
  end
end
