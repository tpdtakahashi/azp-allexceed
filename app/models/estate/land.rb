class Estate::Land < ApplicationRecord
    include ::Estate::Able

    scope :tops, ->{where(parent_id: nil)}
    scope :singles, ->{tops.where(lot_number: nil)}
    scope :lots,  ->{tops.where.not(lot_number: nil)}

    belongs_to :parent, class_name: '::Estate::Land', optional: true

    has_many :divisions,->{order(index_order: :asc)}, class_name: '::Estate::Land', foreign_key: 'parent_id'

    include Tpd::IndexOrderable
    def record_list
        parent.blank? ? nil : parent.divisions
    end


    def land_tsubo_size
        ::Estate::Common.squaremeter_to_tsubo(self.land_area_size)
    end


end
