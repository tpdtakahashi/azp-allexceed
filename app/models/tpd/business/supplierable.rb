module Tpd::Business::Supplierable

  def self.included(base)
    base.extend ClassMethods
    
    base.has_many :customer_relations, :class_name => "Tpd::Business::CustomersSuppliers", :foreign_key => "supplier_id"
    base.has_many :customers, :through => :customer_relations
    
  end
  
  ## class mothods #----------------------
  module ClassMethods
  end
  
  ## instance mothods #-------------------
  
  
end