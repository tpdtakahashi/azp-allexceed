module Tpd::IndexOrderable


    def self.included(base)
        base.extend ClassMethods
        base.InitIndexOrderClass
    end
  
    ## class methods ----------------------------------------
  
    module ClassMethods

        def InitIndexOrderClass
            @@step_number_for_index_order = 100
            before_create :auto_ordering
            attr_accessor :auto_order_off
        end

        def step_number_for_index_order=(val)
            @@step_number_for_index_order = val
        end
        def step_number_for_index_order
            @@step_number_for_index_order
        end
    end
    
    # 対象になるレコードリスト取得
    # デフォルトはレコード全域にされているので再定義すること
    def record_list
        self.class.all
    end
    
    #
    def auto_ordering
        return true if record_list.nil?
        return true if !auto_order_off.blank? && auto_order_off
        if index_order.blank? || index_order == 100
            last_index = record_list.maximum(:index_order)
            last_index ||= self.class.step_number_for_index_order
            self.index_order = last_index + self.class.step_number_for_index_order
        end
    end

    def insert_after(record)
        # 以降のデータのorderをSTEP_NUMBER分ずらす
        record_list.where('index_order > ?', self.index_order).update_all('index_order = index_order + ?', self.class.step_number_for_index_order)
        # record に次のorder番号設定して保存
        record_list.where(index_order: self.index_order).update_all('index_order = index_order + ?', self.class.step_number_for_index_order)
        # 再読込するほどのことでもないので直接調整
        record.index_order = self.index_order + self.class.step_number_for_index_order
    end
    #
    def insert_before(record)
        # 自身のDBレコード含め以降のデータのorderをSTEP_NUMBER分ずらす
        record_list.where('index_order >= ?', self.index_order).update_all('index_order = index_order + ?', self.class.step_number_for_index_order)
        # record に次のorder番号設定して保存
        record_list.where(index_order: record.index_order).update_all(index_order: self.index_order)
        # 再読込するほどのことでもないので直接調整
        record.index_order = self.index_order
        self.index_order = self.index_order + self.class.step_number_for_index_order
    end

    #
    def next_record
        next_index = record_list.where('index_order > ?', self.index_order).minimum(:index_order)
        return nil if next_index.blank?
        next_record = record_list.where(index_order: next_index).first
        next_record
    end
    #
    def prev_record
        prev_index = record_list.where('index_order < ?', self.index_order).maximum(:index_order)
        return nil if prev_index.blank?
        prev_record = record_list.where(index_order: prev_index).first
        prev_record
    end

    #
    def first_record?
        prev_record.blank?
    end
    #
    def last_record?
        next_record.blank?
    end

    #
    def up_index_order
        p_record = prev_record
        prev_index = p_record.index_order
        p_record.index_order = self.index_order
        self.index_order = prev_index
        p_record.save
        self.save
    end
    #
    def down_index_order
        n_record = next_record
        next_index = n_record.index_order
        n_record.index_order = self.index_order
        self.index_order = next_index
        n_record.save
        self.save
    end    

end