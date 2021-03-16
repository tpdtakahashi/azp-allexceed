class Estate::Picture < Tpd::UploadFile::Image

    STEP_NUMBER = 100
    belongs_to :estate, class_name: '::Estate::Common', foreign_key: 'record_id'

    
    include Tpd::IndexOrderable
    def record_list
        estate.images
    end

    before_validation :set_default_params
    def set_default_params
        self.file_category = 'estate'
        self.delete_flg = false
        return true
    end

    def published
        !published_at.blank?
    end
    def published=(val)
        self.published_at = (val == true ? DateTime.now : nil )
    end

    def sub_params(key)
        p = JSON.parse( self.estate.sub_params || '{}' )
        p[key.to_s] || ''
    end
    def set_sub_params(key, val)
        p = JSON.parse( self.estate.sub_params || '{}' )
        p[key.to_s] = val
        self.estate.sub_params = p.to_json
        true
    end



end
