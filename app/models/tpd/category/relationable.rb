module Tpd::Category::Relationable

    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def setup_category(category_class_name: "Category", category_key: "category_id", item_class_name: "Item", item_key: "item_id")
        belongs_to :category, :class_name => category_class_name, :foreign_key => category_key        
        belongs_to :item, :class_name => item_class_name, :foreign_key => item_key
      end
    end


end