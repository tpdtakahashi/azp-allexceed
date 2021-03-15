class CreateEstateHouses < ActiveRecord::Migration[5.0]
  def change
    create_table :estate_houses do |t|
      t.references :common
      t.integer :price
      t.string :madori
      t.float :house_area_size
      t.float :land_area_size
      t.integer :parking_number
      t.date :builded_on
      t.string :madori
      t.text :setsubi

      t.timestamps
    end
  end
end
