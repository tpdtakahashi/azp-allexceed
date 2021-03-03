class Tpd::Person::Location < ActiveRecord::Base
  belongs_to :person, class_name: "::Tpd::Person"
end
