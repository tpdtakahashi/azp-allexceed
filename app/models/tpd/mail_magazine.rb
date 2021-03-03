# -*- encoding: utf-8 -*-
module Tpd::MailMagazine

  def setup_mail_magazine(article_class_name="Tpd::MailMagazine::Article")
    has_many :articles, :class_name => article_class_name, :foreign_key => "mail_magazine_id"
    has_many :undelivery_articles, :class_name => article_class_name, :foreign_key => "mail_magazine_id", :conditions => ["sended_at IS NULL"]
    #has_many :subscribers, :class_name => "Tpd::MailMagazine::Subscriber", :foreign_key => "mail_magazine_id", :conditions => ["deleted_at IS NULL AND registed_at IS NOT NULL"]
    
	include Tpd::MailMagazine::InstanceMethods
	
    before_create :create_access_code
    before_create :create_regist_code
  end
  
  def reset_access_code
    self.all.each do |m|
	  m.create_access_code
	  m.save
	end
  end
  
  def subscriber_class
    Tpd::MailMagazine::Subscriber
  end

  def mail_domain
    Tpd::AppConfig.value(:mail_domain)
  end
  
  def root_path
    "/members"
  end
  
  def path
    root_path + "/mail_magazine"
  end
  def protocol
    Tpd::AppConfig.value(:mail_protocol)
  end
  def url
    protocol + "://" + Tpd::AppConfig.value(:domain)
  end
  
end

module Tpd::MailMagazine::InstanceMethods
  def mail_magazine_title
    return self.label if !self.label.blank?
    prefix = ((self.root? or parent.root?) ? "" : parent.title)
    "#{prefix} #{self.title}"
  end
  
  def regist_mail_address
    "magreg-#{self.access_code}@#{self.class.mail_domain}"
  end
  def accsess_path
    self.class.path + "/#{self.access_code}"
  end
  def accsess_url
    self.class.url + self.accsess_path
  end
  def signup_subscriber_path(subscriber=nil)
    accsess_path + "/signup" + (subscriber.blank? ? "" : "/#{subscriber.code}")
  end
  def signup_subscriber_url(subscriber=nil)
    self.class.url + self.signup_subscriber_path(subscriber)
  end
  
  def build_hash_code(str)
    n = DateTime.now
    digest = Digest::MD5.new
    digest.update(n.strftime("%m%d%H%M%S%N%Y") + str)
    code = digest.to_s.split("").shuffle.join("")
	code[0,8]
  end
  
  def create_access_code
    str = self.title  + "access"
    a_code = build_hash_code(str)
	ret = self.class.where(:access_code => a_code)
	while(!ret.blank?)
	  cnt = (cnt.blank? ? 0 : cnt + 1)
      a_code = build_hash_code(a_code)
      ret = self.class.where(:access_code => a_code)
	end
    self.access_code = a_code
  end
  
  def create_regist_code
    str = self.title  + "regist"
    a_code = build_hash_code(str)
	ret = self.class.where(:regist_code => a_code)
	while(!ret.blank?)
	  cnt = (cnt.blank? ? 0 : cnt + 1)
      a_code = build_hash_code(a_code)
      ret = self.class.where(:regist_code => a_code)
	end
    self.regist_code = a_code
  end
  
 
  
end
