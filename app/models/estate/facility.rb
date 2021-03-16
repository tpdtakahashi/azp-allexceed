class Estate::Facility < ApplicationRecord

    include Tpd::IndexOrderable

    belongs_to :estate, class_name: '::Estate::Common', foreign_key: 'record_id'

    @@category_items = %i(小学校 中学校)

    def record_list
        estate.facilities
    end

end
