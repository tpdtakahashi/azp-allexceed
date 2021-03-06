class CreateEstates < ActiveRecord::Migration[5.0]
  def change
    create_table :estate_commons do |t|
      t.references :agent
      t.string :name
      t.string :summary
      t.string :category

      t.string :zip_code, :limit=>32
      t.string :address_pref, :limit => 32
      t.string :address_city, :limit => 32
      t.string :address_area, :limit => 32
      t.string :address_else, :limit => 64

      #緯度
      t.string :latitude
      #経度
      t.string :longitude

      t.string :elementaly_school
      t.string :junior_high_school
      t.string :station

      t.text :sub_params
      t.text :description
      t.text :pr_comment
      t.text :memo

      #
      t.datetime :published_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
