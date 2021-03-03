module Tpd::Person::Personable
  
  def self.included(base)
    base.extend ClassMethods
    base.InitPersonClass
  end
  
  ## class methods =================================================
  
  module ClassMethods
    
    def InitPersonClass
      belongs_to :person,  :class_name => "Tpd::Person::Base"
      
      scope :person_alives, -> {
        where(Tpd::Person::Base.table_name + ".deleted_at IS NULL").joins(:person)
      }
      
      before_save :save_person
      add_person_methods
    end
    
    def add_person_methods
      begin
        self_columns = column_names
      rescue
        return
      end

      begin
        person_columns = Tpd::Person::Base.column_names
        person_columns.each do |person_column|
          unless person_column =~ /(created_at|updated_at|id)/
            define_method(person_column) { eval("return self.person.#{person_column}") }
            if self_columns.include?(person_column)
              define_method("#{person_column}=") {|value| eval("self[:#{person_column}]=value;self.person.#{person_column}=value") }
            else
              define_method("#{person_column}=") {|value| eval("self.person.#{person_column}=value") }
            end
          end
        end
	  rescue
	  end
    
#    ["name"].each do |name|
#      define_method(name) { eval("return self.person.#{name}") }
#    end
#    ["name"].each do |name|
#      define_method("#{name}=") {|value| eval("self.person.#{name}=value") }
#    end
    
    end
    
  
    def add(person)
     return false if !member?(person)
      member = new({:person_id => @person.id})
      return member.save
    end
  
    def member?(person)
      chk = Person.where(:person_id => person.id).first
      return !chk.blank?
    end
  end

  
  ## instance methods ===================================================
  
  
  def initialize(attributes = nil, options = {})
    super nil,{}
    if attributes.blank? or attributes[:person_id].blank?
    self.build_person
	end
    self.attributes = attributes if !attributes.blank?
    self.created_at = DateTime.now
    self.updated_at = DateTime.now
  end
  

  
  def name
    person.name
  end
  def name=(val)
    person.name=val
  end
  def kana
    person.kana
  end
  def kana=(val)
    person.kana=val
  end

  def address_name
    person.address_name
  end
  def address
    person.address
  end
  def short_address
    person.short_address
  end
  def prefecture_id
    return nil if self.address_pref.blank?
    pref = Tpd::Address::Prefecture.where(:name => self.address_pref).first
    return (pref.blank? ? nil : pref.id)
  end  
  def age
    person.age
  end
  
  def update_attributes(attr)
    super(attr) and person.save
  end
  
  def bank_accounts
    self.person.bank_accounts
  end
  
  def save_person
    person.save
  end
  
  def person_valid?
    ret = person.validate
	person.errors.each {|attr,err| errors.add(attr,err)}
	ret
  end
  
  def to_json
    ret = {name: self.name, kana: self.kana}
    attrs = [ :email, :telephone, :mobile_phone, :birthday, :zip_code, :address_pref, :address_city, :address_area, :address_else]
    attrs.each do |attr|
      ret[attr] = person[attr]
    end
    ret.to_json
  end
end