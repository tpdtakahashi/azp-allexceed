class CreateTpdPeople < ActiveRecord::Migration
  def change
    create_table :tpd_people do |t|
      t.references :perent, :index => true
	  
	  t.string :type
      
      t.string :first_name
      t.string :last_name
      t.string :first_name_kana
      t.string :last_name_kana
      
      t.string :sex_type, :limit => 8
      t.date   :birthday
      
      t.string :email
      t.string :mobile_email
      
      t.string :telephone, :limit => 32
      t.string :fax, :limit => 32
      t.string :mobile_phone, :limit => 32
      
      t.string :zip_code, :limit=>32
      t.string :address_pref, :limit => 32
      t.string :address_city, :limit => 32
      t.string :address_area, :limit => 32
      t.string :address_else, :limit => 64
      
      t.string :honorific, :limit => 16
      
      t.string :in_charge
      
      t.text :description
      
      t.boolean :published_flg, :default => 0
      
      t.datetime :deleted_at

      t.timestamps
    end
    
    create_table :tpd_person_relations, :id => false do |t|
      t.references :owner, :index => true
      t.references :target, :index => true
    end
    
    create_table :tpd_person_groups do |t|
      t.references :parent, :index => true
      t.string :name
	  t.string :code, :unique => true
	  t.string :access_code
	  t.string :regist_code

      t.timestamps
    end
    
    create_table :tpd_person_groups_members, :id => false do |t|
      t.references :person, :index => true
      t.references :group, :index => true
	  t.integer :index_order
    end
    
    create_table :tpd_person_users do |t|
      t.references :person, :index => true
      t.string :type
      
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end  
end
