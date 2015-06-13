class CreateMaskSettings < ActiveRecord::Migration
  def change
    create_table :mask_settings do |t|
      t.string :database
      t.string :table
      t.string :column
      t.string :mask_type
      t.text :fixed_value

      t.timestamps null: false
    end
  end
end
