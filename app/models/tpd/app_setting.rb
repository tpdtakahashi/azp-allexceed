# -*- encoding: utf-8 -*-
class Tpd::AppSetting
  
  def initialize()
    @settings = {}
	Tpd::AppConfig.all.each do |item|
	  @settings[item.code] = item
	end
  end
  
  def [](code)
    @settings[code].value
  end
  
  def label(code)
    @settings[code].name
  end
  
end