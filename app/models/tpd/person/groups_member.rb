class Tpd::Person::GroupsMember < ActiveRecord::Base
  
  belongs_to :group, class_name: "Tpd::Person::Group"
  belongs_to :member, class_name: "Tpd::Person", foreign_key: "person_id"

end