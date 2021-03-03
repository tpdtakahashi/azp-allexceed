module Tpd::Treeable
  
  def self.included(base)
    base.extend ClassMethods
    
    base.belongs_to :parent, :foreign_key => "parent_id", :class_name => base.name
    base.has_many :children, :foreign_key => "parent_id", :class_name => base.name
    
    
    base.scope :roots, lambda {
      where(:parent_id => nil)
    }
  end

  module ClassMethods
  
    def select_leafs(tree_items)
      leafs = []
      tree_items.each {|item| leafs << item if item.children.empty?}
      return leafs
    end
  
  end
  
  ## instance methods
  
  def breadcrumb_name
    ret = ancestors.map {|a| a.label}
    ret << self.label
    return ret.join("/")
  end
  
  ## 子孫
  def descendants(forced = false)
    return @descendants if !@descendants.nil? and !forced
    #@descendants = self.children + self.class.descendants(self.children)
    chldrn = self.children
    des = chldrn
    ret = []
    
    while des.length > 0
      ret = ret + des
      ids = des.map {|d| d.id}
      des = self.class.where(:parent_id => ids).all
    end
    
    @descendants = ret
    
    return @descendants
  end
  
  ## 祖先
  def ancestors(forced = false)
    return @ancestors if !@ancestors.nil? and !forced
    @ancestors = []
    return @ancestors if self.parent_id.nil?
    
    pids = [self.parent.id]
    ret = []
    
    while pids.length > 0
      prnts = self.class.where(:id => pids).all
      pids = prnts.map {|p| p.parent_id}.compact
      @ancestors = prnts + @ancestors
    end
    
    return @ancestors
  end
  
  ## 兄弟
  def brothers
    parent.children
  end
  
  def root
    return self if self.root?
    if @root.blank?
	  prnt = self.parent
	  p = prnt
	  while !p.blank?
	    prnt = p
	    p = p.parent
	  end
	  @root = prnt
	end
	return @root
  end
  
  def root?
    return self.parent_id.nil?
  end
  def branch?
    return !self.children.empty?
  end

end
