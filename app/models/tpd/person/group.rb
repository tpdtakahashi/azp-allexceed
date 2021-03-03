class Tpd::Person::Group < ActiveRecord::Base
  self.table_name = "tpd_person_groups"

  include ::Tpd::Categoryable
  
  setup_category( relation_label: :group,
                  relation_class_name: "::Tpd::Person::GroupsMember",
                  category_key: "group_id",
                  members_label: :members
  )
  
  
  def member?(person)
    self.members.where(id: person.id)
  end
  
end