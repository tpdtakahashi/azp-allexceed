module Tpd::Category::Itemable

    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def setup_category_item( relation_class_name: "CategoryItems", item_key: "item_id")
        
        has_many :category_items, :class_name => relation_class_name, :foreign_key => item_key
        has_many :categories, :through => :category_items
      end
    end


end