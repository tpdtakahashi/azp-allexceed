class Estate < ApplicationRecord
  belongs_to :agent

  has_many :pictures, ->{ order(index_order: :asc) }, class_name: '::Estate::Picture', foreign_key: 'record_id'

  has_many :images


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

end
