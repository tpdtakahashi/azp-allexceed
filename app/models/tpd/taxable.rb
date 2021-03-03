module Tpd::Taxable
  
  def self.included(base)
    base.extend ClassMethods
    base.initTaxableClass
    
  end
  
  
  ## class methods -------------------------------------------
  
  module ClassMethods
    
    def initTaxableClass
      @@DefaultTaxRate = nil
    end
    
    def defaultTaxRate
      @@DefaultTaxRate = Tpd::AppConfig.value(:tax_rate) if @@DefaultTaxRate.nil?
      @@DefaultTaxRate
    end
    ## 消費税込み価格(小数点以下切り捨て)
    def taxInclude(tax_excluded_price, tax_rate=nil)
      tax_rate ||= defaultTaxRate
      (tax_excluded_price.to_f * (1.0 + (tax_rate.to_f / 100.0))).floor
    end

    ## 消費税抜き価格(小数点以下切り上げ)
    def taxExclude(tax_included_price, tax_rate=nil)
      tax_rate ||= defaultTaxRate
      (tax_included_price.to_f / (1.0 + (tax_rate.to_f / 100.0))).ceil
    end
    
    ## 消費税額
    def tax_value(tax_included_price, tax_rate=nil)
    　　tax_rate ||= defaultTaxRate   
   　　 tax_included_price - taxExclude(tax_included_price, tax_rate)
　　  end

     ## 消費税
  end
  
  ## instance methods ----------------------------------------
  
  def calc_price
    self.price
  end
  def calc_cost
    self.cost
  end
  
  def default_tax_rate
    (self.respond_to?(:tax_rate) and self.tax_rate.blank? ? self.class.defaultTaxRate : self.tax_rate)
  end
  
  ## 消費税込み価格
  def price_included_tax(force_tax_rate=nil)
    force_tax_rate ||= default_tax_rate
    self.price_included_tax? ? self.calc_price : self.class.taxInclude(self.calc_price, force_tax_rate)
  end
  
  ## 消費税抜き価格
  def price_excluded_tax(force_tax_rate=nil)
    force_tax_rate ||= default_tax_rate
    self.price_included_tax? ? self.class.taxExclude(self.calc_price, force_tax_rate) : self.calc_price
  end
  
  ## 消費税額
  def price_tax(force_tax_rate=nil)
    force_tax_rate ||= default_tax_rate 
    self.price_included_tax(force_tax_rate) - self.price_excluded_tax(force_tax_rate)
  end
  
  ## 税込み？
  def price_tax_included?
    self.price_tax_included
  end
  ## 税込み？
  def price_included_tax?
    self.price_tax_included
  end
  
  
  ## 消費税込み原価
  def cost_included_tax(force_tax_rate=nil)
    force_tax_rate ||= default_tax_rate
    self.cost_included_tax? ? self.calc_cost : self.class.taxInclude(self.calc_cost, force_tax_rate)
  end
  
  ## 消費税抜き原価
  def cost_excluded_tax(force_tax_rate=nil)
    force_tax_rate ||= default_tax_rate
    self.cost_included_tax? ? self.class.taxExclude(self.calc_cost, force_tax_rate) : self.calc_cost
  end
  
  ## 消費税額
  def cost_tax(force_tax_rate=nil)
    force_tax_rate ||= default_tax_rate 
    self.cost_included_tax(force_tax_rate) - self.cost_excluded_tax(force_tax_rate)
  end
  
  ## 税込み？
  def cost_tax_included?
    self.cost_tax_included
  end
  ## 税込み？
  def cost_included_tax?
    self.cost_tax_included
  end  
end