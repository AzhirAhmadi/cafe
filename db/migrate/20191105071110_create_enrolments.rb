class CreateEnrolments < ActiveRecord::Migration[5.2]
  def change
    create_table :enrolments do |t|
      t.references :user, foreign_key: { to_table: 'users' }
      t.references :table, foreign_key: { to_table: 'tables' }

      t.datetime :deleted_at
      t.timestamps
    end
    add_index :enrolments, [:user_id, :table_id, :deleted_at], unique: true
  end
end
