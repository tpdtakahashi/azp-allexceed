module Tpd::Business::Customerable

  def self.included(base)
    base.extend ClassMethods
    
    base.has_many :supplier_relations, :class_name => "Tpd::Business::CustomersSuppliers", :foreign_key => "customer_id"
    base.has_many :suppliers, :through => :supplier_relations
  end
  
  ## class mothods #----------------------
  module ClassMethods
  end
  
  ## instance mothods #-------------------
  
  def clear_suppliers_relations
    self.supplier_relations.clear
  end
  
  
end