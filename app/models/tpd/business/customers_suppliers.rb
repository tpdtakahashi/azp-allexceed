class Tpd::Business::CustomersSuppliers < ActiveRecord::Base
  self.table_name = "tpd_business_customers_suppliers"
  belongs_to :supplier
  belongs_to :customer
end
