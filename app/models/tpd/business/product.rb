class Tpd::Business::Product < ActiveRecord::Base
  self.table_name = "tpd_business_products"
  
  ## カテゴリー利用設定
  include Tpd::Category::Itemable
  @@_CategoryRelationClass = Tpd::Business::Product::CategoryItems
  setup_category_item( relation_class_name: @@_CategoryRelationClass.name )
  def self.CategoryRelationClass
    @@_CategoryRelationClass
  end
  
  ## 消費税関連設定
  include Tpd::Taxable
  
  def initialize(attributes = nil)
    super attributes
    self.tax_rate ||= self.class.defaultTaxRate.to_i
  end
  
  ## ファイル
  include Tpd::UploadFile::Attachable
  attr_accessor :default_image_delete_flg
  
  extend_single_file :default_image_file, :class_name => "Tpd::UploadFile::Image", :foreign_key => "default_file_id"
  
  after_save :save_default_image_file
  def save_default_image_file
    default_image_file.save if !default_image_file.blank?
  end
  
  def default_image=(val)
    return if val.blank?
    if default_image_file.blank?
      build_default_image_file(:upfile => val, :file_category => "product", :delete_flg => default_image_delete_flg)
    else
      default_image_file.attributes = {:upfile => val, :file_category => "product", :delete_flg => default_image_delete_flg}
    end
  end
  def default_image
    default_image_file
  end
  
end
