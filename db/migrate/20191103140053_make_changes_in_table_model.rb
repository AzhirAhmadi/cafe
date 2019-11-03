class MakeChangesInTableModel < ActiveRecord::Migration[5.2]
  def change
    rename_column :table, :table_number, :table_code
    change_column :table, :capacity, :integer
    add_column :table, :enroled, :integer, default: 0
    add_index :table, [:table_code, :event_id], unique: true
  end
end
