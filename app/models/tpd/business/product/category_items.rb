class Tpd::Business::Product::CategoryItems < ActiveRecord::Base
  
  include Tpd::Category::Relationable
  
  setup_category(category_class_name: "Tpd::Business::Product::Category", item_class_name: "Tpd::Business::Product")
  
end
