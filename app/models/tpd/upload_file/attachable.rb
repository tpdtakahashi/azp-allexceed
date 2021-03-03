module Tpd::UploadFile::Attachable

  def self.included(base)
    base.extend ClassMethods
    base.initAttachmentFile
  end
  
  ## class methods ------------------------
  module ClassMethods
    
    def initAttachmentFile
      Attachment.belongs_to :record, class_name: name, foreign_key: 'record_id'
    end
    
    def extend_single_file(name, options={})
      options[:class_name] ||= "Tpd::UploadFile"
      belongs_to name, options
    end
    
    def extend_multiple_file(name, options={})
      has_many :attach_files, class_name: Attachment.name, foreign_key: 'record_id'
      has_many name, through: 'attach_files'
    end
  end
  
  class Attachment < Tpd::UploadFile::Attachment
    belongs_to :file, class_name: 'Tpd::UploadFile'
  end
  
  ## instance methods ---------------------
  
  def save_single_file(name)
    
  end
  

end