class MakeChangesInTableModel < ActiveRecord::Migration[5.2]
  def change
    rename_column :tables, :table_number, :table_code
    add_index :tables, [:table_code, :event_id], unique: true

    remove_column :tables, :capacity
    add_column :tables, :capacity, :integer
    
    add_column :tables, :enroled, :integer, default: 0
  end
end
