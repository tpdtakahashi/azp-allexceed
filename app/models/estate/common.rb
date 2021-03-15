class ::Estate::Common < ApplicationRecord
    #belongs_to :agent

    @@torihikitaiyou_items = %i(売主 貸主 媒介 代理)

    has_many :images, ->{order(index_order: :asc)}, class_name: '::Estate::Picture', foreign_key: 'record_id'
    has_many :facilities, ->{order(index_order: :asc)}, class_name: '::Estate::Facility', foreign_key: 'record_id'

    has_one :land, class_name: '::Estate::Land'
    has_one :house, class_name: '::Estate::House'
    
    def self.select_items(target)
      case target.to_sym
      when :torihikitaiyou then
        return @@torihikitaiyou_items
      when :tikunen then
        return tikunen_items
      when :tikutsuki then
        return tikutsuki_items
      when :parking then
        return parking_items
      else
        return []
      end
    end

    def self.tikunen_items
      ret = []
      1900.upto(Date.today.year + 1) {|n| ret << n}
      ret
    end
    def self.tikutsuki_items
      ret = []
      1.upto(12) {|n| ret << n}
      ret
    end
    def self.parking_items
      ret = []
      0.upto(10) {|n| ret << n}
      ret
    end

    # 単位変換：平米(㎡)⇒坪
    def self.squaremeter_to_tsubo( squaremeter_size )
      (squaremeter_size.to_f * 0.3025).floor(2)
    end
    # 単位変換：坪⇒平米(㎡)
    def self.tsubo_to_squaremeter( tsubo_size )
      (tsubo_size.to_f / 0.3025 ).floor(2)
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
  

    #
    def update_coordinates
    end


    #
    def land?
      !self.land.blank?
    end
    #
    def house?
      !self.house.blank?
    end

  end
  