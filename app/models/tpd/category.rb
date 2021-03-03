# -*- encoding: utf-8 -*-
module Tpd::Category

  def self.included(base)
    base.extend ClassMethods
      # ツリー構造付加
    base.extend Tpd::Treeable
  end

  ## class methods ----------------------------------------
  
  module ClassMethods
    def category_setup(relation_class_name, category_key_name)
      has_many :categories_members,
               :foreign_key => category_key_name,
               :class_name => relation_class_name

    end
  
    def find_by_path(path)
      tree = path.strip.gsub(/(^\/)|(\/$)/,"").split("/")
      item = roots.where(:code => tree.first).first
      tree.shift
      tree.each do |code_name|
        return nil if item.blank?
        item = item.children.where(:code => code_name).first
      end
      return item
    end
  
    def create_by_path(path)
      tree = path.strip.gsub(/(^\/)|(\/$)/,"").split("/")
      item = roots.where(:code => tree.first).first
      if item.blank?
        item = create(title:tree.first,code:tree.first)
      end
      tree.shift
      tree.each do |code_name|
        chld = new(title:code_name,code:code_name)
        item.children << chld
        chld.save
        item = chld
      end
      return item
    end
  end
  
  
  ## instance methods ------------------------------------------------
  
  def new_category_member(attrs={})
    attrs ||= {}
	ci = categories_members.build
	ci.build_member(attrs)
  end
  
  def category_members
    categories_members.order("index_order ASC").includes("member").map {|r| r.item}
  end
  def category_member(member_id)
    category_members.each {|member| return member if member.id == member_id.to_i}
	return nil
  end
  
  def add_category_member(member)
    categories_members.each {|ci| return if ci.member == member}
	ci = categories_members.build
	ci.member = member
  end
  
  def delete_category_members(del_members)
    del_ids = del_members.map {|di| di.id}
    dels = categories_members.where(:member_id => del_ids)
	categories_members.delete(dels)
	categories_members(true)
  end
  
end