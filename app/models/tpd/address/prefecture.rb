class Tpd::Address::Prefecture < ActiveRecord::Base
  self.table_name = "tpd_address_prefectures"
  belongs_to :region, :class_name => "Tpd::Address::Region"

  def shipping_fee
    region.shipping_fee
  end
end