class Tpd::Business::Product::Category < ActiveRecord::Base
  self.table_name = "tpd_business_product_categories"
  
  include Tpd::Categoryable
  
  setup_category( relation_class_name: "Tpd::Business::Product::CategoryItems" )
  
  alias_method :products, :items
  
end