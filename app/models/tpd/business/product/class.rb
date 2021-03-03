class Tpd::Business::Product::Class < ActiveRecord::Base
  
  has_many :products, :foreign_key => "class_id"
  
end