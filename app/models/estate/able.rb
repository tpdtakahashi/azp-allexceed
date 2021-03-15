module ::Estate::Able
    def self.included(base)
        base.extend ClassMethods
        base.initEstatableClass
    end

    ## class methods -------------------------------------------
    module ClassMethods
        def initEstatableClass
            belongs_to :common, class_name: '::Estate::Common', foreign_key: 'common_id', autosave: true
            accepts_nested_attributes_for :common

        end

    end

    #
    def estate
        if self.common.blank?
            self.build_common
        end
        return self.common
    end

    def name
        estate.name
    end
    def name=(val)
        estate.name = val
    end

    def address
      self.estate.blank? ? nil : self.estate.address
    end

    def address_pref
        self.estate.blank? ? nil : estate.address_pref
    end
    def address_pref=(val)
        self.estate.address_pref = val
    end
    def address_city
        self.estate.blank? ? nil : estate.address_city
    end
    def address_city=(val)
        self.estate.address_city = val
    end
    def address_area
        self.estate.blank? ? nil : estate.address_area
    end
    def address_area=(val)
        self.estate.address_area = val
    end
    def address_else
        self.estate.blank? ? nil : estate.address_else
    end
    def address_else=(val)
        self.estate.address_else = val
    end
    def zip_code
        self.estate.blank? ? nil : estate.zip_code
    end
    def zip_code=(val)
        self.estate.zip_code = val
    end

    #
    def elementaly_school
        self.estate.blank? ? nil : estate.elementaly_school
    end
    def elementaly_school=(val)
        self.estate.elementaly_school = val
    end
    #
    def junior_high_school
        self.estate.blank? ? nil : estate.junior_high_school
    end
    def junior_high_school=(val)
        self.estate.junior_high_school = val
    end
    #
    def station
        self.estate.blank? ? nil : estate.station
    end
    def station=(val)
        self.estate.station = val
    end
    # 
    def traffic
        sub_params(:traffic)
    end
    def traffic=(val)
        set_sub_params(:traffic,val)
    end

    #
    def pr_comment
        self.estate.blank? ? nil : estate.pr_comment
    end
    def pr_comment=(val)
        self.estate.pr_comment = val
    end
    def description
        self.estate.blank? ? nil : estate.description
    end
    def description=(val)
        self.estate.description = val
    end
    def memo
        self.estate.blank? ? nil : estate.memo
    end
    def memo=(val)
        self.estate.memo = val
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

    # 取引態様（売主、貸主、媒介、代理）
    # 選択
    # ::Estate::Common.select_items(:torihikitaiyou)
    def torihikitaiyou
        sub_params(:torihikitaiyou)
    end
    def torihikitaiyou=(val)
        set_sub_params(:torihikitaiyou,val)
    end

    # 建ぺい率
    def kenpei
        sub_params(:kenpei)
    end
    def kenpei=(val)
        set_sub_params(:kenpei,val)
    end

    # 容積率
    def youseki
        sub_params(:youseki)
    end
    def youseki=(val)
        set_sub_params(:youseki,val)
    end

    # 地目
    def chimoku
        sub_params(:chimoku)
    end
    def chimoku=(val)
        set_sub_params(:chimoku,val)
    end
    # 用途地域
    def youto
        sub_params(:youto)
    end
    def youto=(val)
        set_sub_params(:youto,val)
    end
    # 道路
    def douro
        sub_params(:douro)
    end
    def douro=(val)
        set_sub_params(:douro,val)
    end
    # 区域
    def kuiki
        sub_params(:kuiki)
    end
    def kuiki=(val)
        set_sub_params(:kuiki,val)
    end

    #
    def syoukai_label_1
        sub_params(:syoukai_label_1)
    end
    def syoukai_label_1=(val)
        set_sub_params(:syoukai_label_1,val)
    end
    #
    def syoukai_label_2
        sub_params(:syoukai_label_2)
    end
    def syoukai_label_2=(val)
        set_sub_params(:syoukai_label_2,val)
    end
    #
    def syoukai_label_3
        sub_params(:syoukai_label_3)
    end
    def syoukai_label_3=(val)
        set_sub_params(:syoukai_label_3,val)
    end
    #
    def syoukai_label_4
        sub_params(:syoukai_label_4)
    end
    def syoukai_label_4=(val)
        set_sub_params(:syoukai_label_4,val)
    end
    #
    def syoukai_memo_1
        sub_params(:syoukai_memo_1)
    end
    def syoukai_memo_1=(val)
        set_sub_params(:syoukai_memo_1,val)
    end
    #
    def syoukai_memo_2
        sub_params(:syoukai_memo_2)
    end
    def syoukai_memo_2=(val)
        set_sub_params(:syoukai_memo_2,val)
    end
    #
    def syoukai_memo_3
        sub_params(:syoukai_memo_3)
    end
    def syoukai_memo_3=(val)
        set_sub_params(:syoukai_memo_3,val)
    end
    #
    def syoukai_memo_4
        sub_params(:syoukai_memo_4)
    end
    def syoukai_memo_4=(val)
        set_sub_params(:syoukai_memo_4,val)
    end

end
