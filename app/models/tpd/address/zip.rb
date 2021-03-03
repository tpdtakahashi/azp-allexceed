class Tpd::Address::Zip < ActiveRecord::Base
  self.table_name = "tpd_address_zips"
  belongs_to :prefecture
#  belongs_to :city
end
