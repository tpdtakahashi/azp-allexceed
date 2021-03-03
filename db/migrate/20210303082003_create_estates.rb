class CreateEstates < ActiveRecord::Migration[5.0]
  def change
    create_table :estates do |t|
      t.references :agent
      t.string :name
      t.string :summary

      t.text :option_params
      t.text :description

      t.string :zip_code, :limit=>32
      t.string :address_pref, :limit => 32
      t.string :address_city, :limit => 32
      t.string :address_area, :limit => 32
      t.string :address_else, :limit => 64

      #緯度
      t.string :latitude
      #経度
      t.string :longitude

      t.datetime :published_flg
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
