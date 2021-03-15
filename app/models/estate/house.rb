class Estate::House < ApplicationRecord
  include ::Estate::Able

  # 土地面積（坪）
  def land_tsubo_size
    ::Estate::Common.squaremeter_to_tsubo(self.land_area_size)
  end

  # 延べ床面積（坪）
  def house_tsubo_size
    ::Estate::Common.squaremeter_to_tsubo(self.house_area_size)
  end


  # 間取り説明
  def madori_info
    sub_params(:madori_info)
  end
  def madori_info=(val)
      set_sub_params(:madori_info,val)
  end
  
  # 駐車場説明
  def parking_info
    sub_params(:parking_info)
  end
  def parking_info=(val)
      set_sub_params(:parking_info,val)
  end

  # 築年
  def builded_on_year=(val)
    @builded_on_year = val.to_i
  end
  def builded_on_year
    self.builded_on.blank? ? 2000 : self.builded_on.year
  end
  # 築月
  def builded_on_month=(val)
    @builded_on_month = val.to_i
  end
  def builded_on_month
    self.builded_on.blank? ? Date.today.month : self.builded_on.month
  end


  before_save :create_builded_on
  def create_builded_on
    unless @builded_on_year.blank? && @builded_on_month.blank?
      self.builded_on = Date.new(@builded_on_year, @builded_on_month, 1)
    end
  end

  # 
  def denki
    sub_params(:denki)
  end
  def denki=(val)
    set_sub_params(:denki,val)
  end
  # 
  def gas
    sub_params(:gas)
  end
  def gas=(val)
    set_sub_params(:gas,val)
  end
  # 
  def suido
    sub_params(:suido)
  end
  def suido=(val)
    set_sub_params(:suido,val)
  end
  # 
  def gesui
    sub_params(:gesui)
  end
  def gesui=(val)
    set_sub_params(:gesui,val)
  end

end
