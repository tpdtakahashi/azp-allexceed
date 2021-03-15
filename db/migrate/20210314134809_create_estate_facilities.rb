class CreateEstateFacilities < ActiveRecord::Migration[5.0]
  def change
    create_table :estate_facilities do |t|
      t.references :record

      t.integer :distance

      t.string :name
      t.string :summary
      t.string :category
      t.integer :index_order

      t.string :zip_code, :limit=>32
      t.string :address_pref, :limit => 32
      t.string :address_city, :limit => 32
      t.string :address_area, :limit => 32
      t.string :address_else, :limit => 64

      #緯度
      t.string :latitude
      #経度
      t.string :longitude

      t.text :sub_params
      t.text :description

      t.datetime :published_at

      t.timestamps
    end
  end
end
