class ViewBlock < ApplicationRecord
    belongs_to :estate,  class_name: '::Estate::Common'


    has_many :images, ->{order(index_order: :asc)}, class_name: '::Estate::Picture', foreign_key: 'record_id'
    has_many :facilities, ->{order(index_order: :asc)}, class_name: '::Estate::Facility', foreign_key: 'record_id'


    include Tpd::IndexOrderable
    def record_list
        estate.view_blocks
    end

end
