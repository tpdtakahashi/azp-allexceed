# -*- encoding: utf-8 -*-


class Tpd::UploadFile::Image < Tpd::UploadFile

  #@@image_default_size = [500,500]
  @@image_default_size = nil
  
  #@@image_size = {"l" => [400,400],"m" => [200,200],"ms"=>[150,150], "s" => [100,100], "ss" => [80,80], "sss" => [60,60]}
  @@image_size = {"l" => [600,600],"m" => [400,400],"s" => [300,300],"thumb" => [100,100]}

  def path(op=nil)
    super (op || "org")
  end
  
  def url(size=nil)
    img_url(size)
  end
  def self.blank_image_url
    "input_image.png"
  end
  
  ##
  def get_image(size=nil)
    return nil if file_data.nil?
    
    img = Magick::Image.from_blob( file_data ).shift
	
    if @@image_size.include?( size )
      isize = @@image_size[size]
    elsif size.class == Array
      isize = size
    else
	  if @@image_default_size.blank? or size == "orignal"
	    isize = [img.rows, img.columns]
	  else
        isize = @@image_default_size
	  end
    end
    
	img.format = "JPG" if img.format == "PDF"
    per_row = isize[0].to_f / img.rows.to_f
    per_col = isize[1].to_f / img.columns.to_f
    new_img = img.resize( per_row > per_col ? per_col : per_row )
    
    return new_img.to_blob
  end  
  
########################################
## proteted instance method
protected

  #==<< filter methods >>==============================
  
  
  ##
  def check_image_file
    image = Magick::Image.from_blob(self.content)
  end

  #==<< call back methods >>============================
  
  def before_validation
    logger.debug 'Tpd::UploadFile::Image#before_validation'
  end
  
  def after_save
  end
  def save_file_data
    logger.debug 'Tpd::UploadFile::Image#save_file_data'
    if set_data
      logger.debug 'Tpd::UploadFile::Image#save_file_data  set_data'
      self.delete_file_data if exists_old_file?
      self.save_file_name = build_file_name
      if self.check_dir(File.dirname(self.path))
        logger.debug 'Tpd::UploadFile::Image#save_file_data  path: ' + self.path
        File.open(self.path,"wb", 0777) {|f| f.write( get_image ) }
        @@image_size.each do |size,v|
          logger.debug 'Tpd::UploadFile::Image#save_file_data  path: ' + self.path(size)
		      if check_dir(File.dirname(self.path(size)))
            File.open(self.path(size), "wb", 0777) {|fp| fp.write( get_image( size ) ) }
		      end
		    end
      end
	#check_dir(self.path)
    #  File.open(self.path,"wb") {|f| f.write( get_image(@@image_default_size) ) }
    #  @@image_size.each do |size,v|
    #    check_dir(File.dirname(self.path(size)))
    #    File.open(self.path(size), "wb") {|fp| fp.write( get_image( size ) ) }
    # end
    end
  end
  
  def after_destroy
    logger.debug 'Tpd::UploadFile::Image#after_destroy'
  end
  def delete_file_data
    logger.debug 'Tpd::UploadFile::Image#delete_file_data'
    if !file_name.blank? and (File.exists?(path_of_data))
      File.unlink( path("org") )
      @@image_size.each {|size,v| File.unlink(self.path(size))}
    end
    
  end

end