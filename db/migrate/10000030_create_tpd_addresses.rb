class CreateTpdAddresses < ActiveRecord::Migration
  def change
    create_table :tpd_address_regions do |t|
    t.string :name
    t.integer :shipping_fee

      t.timestamps
    end
    create_table :tpd_address_prefectures do |t|
      t.references :region, :index => true
      t.string :name
      t.integer :shipping_fee

      t.timestamps
    end
    create_table :tpd_address_zips do |t|
      t.string :code
      t.references :prefecture, index: true
      t.references :city, index: true
      t.string :prefecture_name
      t.string :city_name
      t.string :area_name

      t.timestamps
    end
  end
end