# -*- encoding: utf-8 -*-
module Tpd::Category::Member

  def category_member_setup(relation_class_name)
    has_many :categories_members, :foreign_key => "member_id", :class_name => relation_class_name, :dependent => :delete_all
	
	# インスタンスメソッド定義
    include Tpd::Category::Member::InstanceMethods
	
  end
end

module Tpd::Category::Member::InstanceMethods

  def categories
    categories_members.map {|r| r.category}
  end
  
  def categories=(new_categories)
    categories_members.clear
	new_categories.each {|category| add_category(category)}
  end
  
  def add_category(category)
    categories_members.each {|ci| return if ci.category == category}
	ci = categories_members.build
	ci.category = category
  end
  
  def category_belongs_to?(category)
    categories_members.map do |r|
      if (category.new_record? and (r.category == category) )
	    return true
	  elsif (r.category.id == category.id)
	    return true
	  end
	end
	return false
  end
  
  def category_index(category,index=nil)
    categories_members.each do |ci|
	  if ci.category_id == category.id
	    ci.index_order = index if !index.blank?
	    return ci.index_order
	  end
	end
	return 0
  end
  
  def delete_relation
    
  end

end