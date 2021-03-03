class ::Tpd::Person::User < ActiveRecord::Base
  
  belongs_to :person, class_name: "::Tpd::Person"
  has_secure_password
  
  before_save :copy_person_data
  
  def copy_person_data
    email = person.email
  end
  
end