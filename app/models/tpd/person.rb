class ::Tpd::Person < ActiveRecord::Base
  self.table_name = 'tpd_people'
  

  has_one :user, class_name: "::Tpd::Person::User"

  has_one :location_watch, class_name: "Tpd::Person::Location::Watch"
  
  
  # attr_accessible :title, :body
#  attr_accessible :last_name,:first_name, :last_name_kana,:first_name_kana,:zip_code,:telephone,:fax,
#					:address_pref,:address_city,:address_area,:address_else,:email,
#					:customer_ids, :supplier_ids
					
					
  @@Honorifics = ["様","御中"]


  
  def name
    last_name.to_s + first_name.to_s
  end
  def name=(val)
    self.first_name = val
  end
  
  def kana
    last_name_kana.to_s + first_name_kana.to_s
  end
  def kana=(val)
    self.first_name_kana = val
  end
  
  # 住所（地域名まで。番地等が除かれる￥）
  def address_name
    ret = ""
    ret << self.address_pref if !self.address_pref.blank?
    ret << self.address_city if !self.address_city.blank?
    ret << self.address_area if !self.address_area.blank?
    return ret
  end
  
  # 住所（全部）
  def address
    ret = address_name
    ret << self.address_else if !self.address_else.blank?
    return ret
  end
  def full_address
    return self.address
  end
  ##-------------------
  ##
  def short_address
    adrs = address_pref.to_s
    adrs += address_city.to_s
    return adrs
  end  

  # 送料（Tpd::Address::Region より読み出し）
  def shipping_fee
    pref = Tpd::Address::Prefecture.where(name: self.address_prefecture).first
    pref.blank? ? nil : pref.region.shipping_fee
  end


  def age
    return nil if birthday.blank?
    
    today = Date.today
    return (today.year - birthday.year) - (today.yday > birthday.yday ? 0 : 1)
  end
  

  
  
#======================================

  def self.Honorifics
    @@Honorifics
  end
  
end