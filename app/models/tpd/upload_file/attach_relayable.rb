module Tpd::UploadFile::AttachRelayable

  def self.included(base)
    base.extend ClassMethods
  end
  
  ## class methods ------------------------
  module ClassMethods
    def attach_file( name, options={} )
      options[:class_name] ||= "Tpd::UploadFile"
      options[:foreign_key] ||= "file_id"
      belongs_to name, options
    end
    def belongs_to_record( name, options={} )
      options[:foreign_key] ||= "record_id"
      belongs_to name, options
    end
  end
  
  ## instance methods ---------------------
  

end