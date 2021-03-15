class Estate::Facility < ApplicationRecord

    STEP_NUMBER = 100
    belongs_to :estate, class_name: '::Estate::Common', foreign_key: 'record_id'


    @@category_items = %i(小学校 中学校)

    def record_list
        estate.facilities
    end


    before_create :auto_ordering
    def auto_ordering
        if index_order.blank? || index_order == 100
            last_index = record_list.maximum(:index_order)
            last_index ||= STEP_NUMBER
            self.index_order = last_index + STEP_NUMBER
        end
    end

    def insert_after(record)
        # 以降のデータのorderをSTEP_NUMBER分ずらす
        record_list.where('index_order > ?', self.index_order).update_all('index_order = index_order + ?', STEP_NUMBER)
        # record に次のorder番号設定して保存
        record_list.where(index_order: self.index_order).update_all('index_order = index_order + ?', STEP_NUMBER)
        # 再読込するほどのことでもないので直接調整
        record.index_order = self.index_order + STEP_NUMBER
    end
    #
    def insert_before(record)
        # 自身のDBレコード含め以降のデータのorderをSTEP_NUMBER分ずらす
        record_list.where('index_order >= ?', self.index_order).update_all('index_order = index_order + ?', STEP_NUMBER)
        # record に次のorder番号設定して保存
        record_list.where(index_order: record.index_order).update_all(index_order: self.index_order)
        # 再読込するほどのことでもないので直接調整
        record.index_order = self.index_order
        self.index_order = self.index_order + STEP_NUMBER
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