class CreateMaskSettings < ActiveRecord::Migration
  def change
    create_table :mask_settings do |t|
      t.comment 'Manage settings for masking data'
      t.string :db_key,     null: false,  comment: 'key name in db/config/database.yml'
      t.string :table,      null: false,  comment: 'table name'
      t.string :column,     null: false,  comment: 'column name'
      t.string :mask_type,  null: false,  comment: 'type of masking'
      t.text :fixed_value,                comment: 'fixed value to fill column value'

      t.timestamps null: false
    end

    add_index :mask_settings, [:db_key, :table, :column], unique: true
  end
end
