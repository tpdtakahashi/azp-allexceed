class CreateEstateLands < ActiveRecord::Migration[5.0]
  def change
    create_table :estate_lands do |t|
      t.references :common

      t.integer :price
      t.float :land_area_size

      t.references :parent
      t.integer :lot_number, default: 1


      t.timestamps
    end
  end
end
