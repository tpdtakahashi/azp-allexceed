# -*- encoding: utf-8 -*-
require 'rubygems'
require 'RMagick'
require 'fileutils'
class Tpd::UploadFile < ActiveRecord::Base
  self.table_name = "tpd_upload_files"
  
#  attr_accessible :title,:summary,:file_category,:upfile  
  attr_accessor :name_prefix
  attr_accessor :delete_flg

  
 # has_and_belongs_to_many :articles

  scope :published, -> {where(published: 1)}

  
  
  before_update :check_delete
  before_save :save_file_data
  before_destroy :delete_file_data
  
  validates_presence_of :file_category
  validates_presence_of :file_type
  validates_presence_of :file_data
  validates_presence_of :file_name
  
  
  def validate

#    errors.add(:file_type, "CSVファイルでない可能性があります。") if check_csv_file
#    errors.add( :file_type, "画像ファイルではありません" ) if check_image_file
  rescue
    errors.add_to_base("データ検査中に未知のエラーが発生しました")
  end

##################################
## public instance method
public
  
  
  def set_data
    @set_data.blank? ? false : @set_data
  end
  def set_data=(val)
    @set_data = val
  end
  
  def to_label
    file_name
  end
  
  def self.categories
    ["maker_products","uebun_products","sales"]
  end
  
  def type_name
  end
  
  def root_dir
    @root_dir.blank? ? Dir.pwd : @root_dir
  end
  
  def path(op=nil)
    root_dir + "/" + path_of_data(op)
  end
  
  def exists_old_file?
    !self.save_file_name.blank?
  end
  
  def build_file_name
    n = DateTime.now
    digest = Digest::MD5.new
    digest.update(n.strftime("%Y%m%d%H%M%S%N").reverse + name_prefix.to_s + self.file_name)
    ret  = digest.to_s[0,5] + n.strftime("%d%m%H%M%Y")
    ret += File.extname(file_name)
    ret
  end
  
  def path_of_data(op=nil)
    rel_dir + (op.blank? ? "" : "/#{op}" ) + "/#{self.save_file_name}"
  end
  
  def rel_dir
#    "upload/#{type.tableize}/#{file_category}"
    "upload/#{file_category}"
  end
  
  def img_url(op=nil)
    "/images/#{file_category}#{(op.blank? ? "/m" : "/#{op}" )}/#{self.save_file_name}"
  end
  
  def upfile=(d)
    self.up_data = d
  end
  
  def up_data=(data)
    @file_data = data.read
    self.file_type = data.content_type
    self.file_name = data.original_filename
    @set_data = true
  end
  
  def file_data=(data)
    @file_data = data
  end
  
  def file_data
    if @file_data.nil? and !file_name.blank?
      @file_data = nil
      File.open(path,"rb") {|fp| @file_data = fp.read}
      return nil if @file_data.blank?
    end
    return @file_data
  end
  
  ##
  def get_file_data(size=nil)
    return nil if file_data.nil?    
    return file_data
  end
  

    
########################################
## proteted instance method
protected
  
  def check_dir(dir)
    if !Dir.exists?(dir)
      p_dir = File.dirname(dir)
      if p_dir == "." or check_dir(p_dir)
        return false if Dir.mkdir(dir) != 0
      else
        return false
      end
    end
    return true
  end
  

  #==<< filter methods >>==============================
  
  ##
  def check_csv_file
    fixed != "csv" or file_type == "text/csv"
  end
  
  ##
  def check_image_file
    image = Magick::Image.from_blob(self.content)
  end

  #==<< call back methods >>============================
  
  def before_validation
    logger.debug 'Tpd::UploadFile#before_validation'
  end
  
  def after_save
    logger.debug 'Tpd::UploadFile#after_save'
  end
  def save_file_data
    logger.debug 'Tpd::UploadFile#save_file_data'
    if set_data
      self.delete_file_data if exists_old_file?
      self.save_file_name = build_file_name
	  
	    FileUtils.mkdir_p(File.dirname(self.path))
      File.open(self.path,"wb", 0777) {|f| f.write( self.file_data ) }
    end
  end
  
  def after_destroy
    logger.debug 'Tpd::UploadFile#after_destroy'
  end
  def delete_file_data
    logger.debug 'Tpd::UploadFile#delete_file_data'
    if !file_name.blank? and (File.exists?(path_of_data))
      File.unlink( path )
    end
    
  end
  
  def check_delete
    if !delete_flg.blank?
      self.destroy
      return false
    end
    return true
  end
  
  
###########################################
# public class method
public

  def self.clean_up( days_ago )
    destroy_all(["created_at < ?",Date.today - days_ago])
  end
end
