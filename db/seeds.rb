# -*- encoding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

## 基本設定
Tpd::AppConfig.create(:name=>"サイトタイトル", :code=>"title", :value_string=>"Allexceed", :value_type=>"string", :system_lock => 1)
Tpd::AppConfig.create(:name=>"サイト名", :code=>"site_name", :value_string=>"Allexceed", :value_type=>"string", :system_lock => 1)
Tpd::AppConfig.create(:name=>"管理ページタイトル", :code=>"admin_title", :value_string=>"Allexceed管理", :value_type=>"string", :system_lock => 1)
Tpd::AppConfig.create(:name=>"サイトキーワード", :code=>"meta_keywords", :value_string=>"", :value_type=>"string", :system_lock => 1)
Tpd::AppConfig.create(:name=>"サイト概要", :code=>"meta_description", :value_string=>"", :value_type=>"string", :system_lock => 1)
Tpd::AppConfig.create(:name=>"サイトドメイン", :code=>"domain", :value_string=>"", :value_type=>"string", :system_lock => 1)
Tpd::AppConfig.create(:name=>"お知らせメール用プロトコル", :code=>"mail_protocol", :value_string=>"https", :value_type=>"string", :system_lock => 1)
Tpd::AppConfig.create(:name=>"お知らせメール用ドメイン", :code=>"mail_domain", :value_string=>"", :value_type=>"string", :system_lock => 1)
Tpd::AppConfig.create(:name=>"所有者", :code=>"owner", :value_string=>"", :value_type=>"string", :system_lock => 1)
Tpd::AppConfig.create(:name=>"消費税率", :code=>"tax_rate", :value_string=>"10.0", :value_type=>"float", :system_lock => 1)
Tpd::AppConfig.create(:name=>"管理ページ認証", :code=>"admin_lock", :value_string=>"1", :value_type=>"boolean", :system_lock => 1)

## region
hokkaido_region = Tpd::Address::Region.create(:name=>"北海道")
touhoku_region = Tpd::Address::Region.create(:name=>"東北")
kanto_region = Tpd::Address::Region.create(:name=>"関東")
tyubu_region = Tpd::Address::Region.create(:name=>"中部")
kinki_region = Tpd::Address::Region.create(:name=>"近畿")
tyugoku_region = Tpd::Address::Region.create(:name=>"中国")
shikoku_region = Tpd::Address::Region.create(:name=>"四国")
kyusyu_region = Tpd::Address::Region.create(:name=>"九州")
okinawa_region = Tpd::Address::Region.create(:name=>"沖縄")

## 都道府県
Tpd::Address::Prefecture.create(:name=>"北海道", :region_id => hokkaido_region.id)
["青森県","岩手県","宮城県","秋田県","山形県","福島県"].each {|pref| Tpd::Address::Prefecture.create(:name=>pref, :region_id => touhoku_region.id)}
["茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県"].each {|pref| Tpd::Address::Prefecture.create(:name=>pref, :region_id => kanto_region.id)}
["新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県"].each {|pref| Tpd::Address::Prefecture.create(:name=>pref, :region_id => tyubu_region.id)}
["三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県"].each {|pref| Tpd::Address::Prefecture.create(:name=>pref, :region_id => kinki_region.id)}
["鳥取県","島根県","岡山県","広島県","山口県"].each {|pref| Tpd::Address::Prefecture.create(:name=>pref, :region_id => tyugoku_region.id)}
["徳島県","香川県","愛媛県","高知県"].each {|pref| Tpd::Address::Prefecture.create(:name=>pref, :region_id => shikoku_region.id)}
["福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県"].each {|pref| Tpd::Address::Prefecture.create(:name=>pref, :region_id => kyusyu_region.id)}
Tpd::Address::Prefecture.create(:name=>"沖縄県", :region_id => okinawa_region.id)

require "./db/zipcode/import"


puts "group table : #{Tpd::Person::Group.table_name}"
if Tpd::Person::Group.where(code: "administrator").first.blank?
  admin_root_group = Tpd::Person::Group.create(name: "administrator", code: "administrator")
  system_group = Tpd::Person::Group.create(name: "システム", code: "system", parent_id: admin_root_group.id)
  admin_group = Tpd::Person::Group.create(name: "管理者", code: "admin", parent_id: admin_root_group.id)
  Tpd::AppConfig.create(:name=>"システムグループID", :code=>"system_group_id", :value_string=>system_group.id.to_s, :value_type=>"integer", :system_lock => 1)
  Tpd::AppConfig.create(:name=>"管理グループID", :code=>"administrator_group_id", :value_string=>admin_group.id.to_s, :value_type=>"integer", :system_lock => 1)  
end

if Tpd::Person.count < 1
  system_user = Tpd::Person.create(name: "システム管理者", email: "tripod@t-pod.jp")
  system_group = Tpd::Person::Group.where(code: "system").first if system_group.blank?
  system_group.members << system_user
  system_group.save

  Tpd::Person::User.create(person_id: system_user.id, password: "ryo2431", password_confirmation: "ryo2431")
  
  ## システムユーザーIDをappconfigに登録
  Tpd::AppConfig.create(:name=>"システム管理者ID", :code=>"system_user_id", :value_string=>system_user.id, :value_type=>"integer", :system_lock => 1)
  
  ## オーナー設定
  owner = ShopOwner.new
  owner.name = "Allexceed"
  owner.kana = "アレクシード"
  owner.zip_code = "3200051";
  owner.address_pref = "栃木県";
  owner.address_city = "宇都宮市";
  owner.address_area = "上戸祭町3014-3";
  owner.address_else = "ヒルサイド上戸祭Ａ棟2Ｆ";
  owner.telephone = "028-666-4162";
  owner.fax = "028-666-4163";
  if !owner.save
   puts owner.errors.full_messages
  else
   puts("ok")
  end
  ## オーナーIDをappconfigに登録
  Tpd::AppConfig.create(:name=>"オーナーID", :code=>"shop_owner_id", :value_string=>owner.person.id, :value_type=>"integer", :system_lock => 1)


  
  
end


