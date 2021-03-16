class CreateViewBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :view_blocks do |t|
      t.references :estate
      t.string :mode
      t.integer :column_number, default: 1
      t.text :sub_params
      t.integer :index_order, default: 100

      t.timestamps
    end
  end
end
