class CreateTpdBaseTables < ActiveRecord::Migration
  def change
    create_table :tpd_app_configs do |t|
      t.string :name
      t.string :code
      t.string :value_string
      t.string :value_type
      
      t.boolean :system_lock, :default => 0

      t.timestamps
    end
  end
  
  
end