# -*- encoding: utf-8 -*-
class Tpd::AppConfig < ActiveRecord::Base
  self.table_name = 'tpd_app_configs'

#  attr_accessible :name,:code,:value_string,:value_type,:system_lock
  
  #
  def self.item(code)
    where(:code => code).first
  end
  
  #
  def self.value(code)
    conf = item(code.to_s)
    return conf.value
  end
  
  
  #
  def value
    ret = nil
    case self.value_type
      when "integer", "int", "i"
        ret = self.value_string.to_i
      when "float", "f"
        ret = self.value_string.to_f
      when "boolean", "bool", "b"
        ret = (self.value_string.to_i == 1)
      else
        ret = self.value_string
    end
    return ret
  end
  
  
  
end

