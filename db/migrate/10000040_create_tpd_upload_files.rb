class CreateTpdUploadFiles < ActiveRecord::Migration
  def change
    create_table :tpd_upload_files do |t|
      t.string :type
      t.references :record
      t.string :fixed, :limit=>12
      t.string :file_category
      t.string :file_name
      t.string :file_type
      t.string :save_file_name
      t.string :title
      t.integer :index_order
	    t.string :summary
      t.text :comment
      t.integer :index_order, default: 100
      t.timestamps
    end
  end
end
