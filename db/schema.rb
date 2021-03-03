# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210303082138) do

  create_table "agents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id"
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["person_id"], name: "index_agents_on_person_id", using: :btree
  end

  create_table "estates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "agent_id"
    t.string   "name"
    t.string   "summary"
    t.text     "option_params", limit: 65535
    t.text     "description",   limit: 65535
    t.string   "zip_code",      limit: 32
    t.string   "address_pref",  limit: 32
    t.string   "address_city",  limit: 32
    t.string   "address_area",  limit: 32
    t.string   "address_else",  limit: 64
    t.string   "latitude"
    t.string   "longitude"
    t.datetime "published_flg"
    t.datetime "deleted_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["agent_id"], name: "index_estates_on_agent_id", using: :btree
  end

  create_table "tpd_address_prefectures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "region_id"
    t.string   "name"
    t.integer  "shipping_fee"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["region_id"], name: "index_tpd_address_prefectures_on_region_id", using: :btree
  end

  create_table "tpd_address_regions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "shipping_fee"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tpd_address_zips", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "code"
    t.integer  "prefecture_id"
    t.integer  "city_id"
    t.string   "prefecture_name"
    t.string   "city_name"
    t.string   "area_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["city_id"], name: "index_tpd_address_zips_on_city_id", using: :btree
    t.index ["prefecture_id"], name: "index_tpd_address_zips_on_prefecture_id", using: :btree
  end

  create_table "tpd_app_configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "code"
    t.string   "value_string"
    t.string   "value_type"
    t.boolean  "system_lock",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tpd_people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "perent_id"
    t.string   "type"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "first_name_kana"
    t.string   "last_name_kana"
    t.string   "sex_type",        limit: 8
    t.date     "birthday"
    t.string   "email"
    t.string   "mobile_email"
    t.string   "telephone",       limit: 32
    t.string   "fax",             limit: 32
    t.string   "mobile_phone",    limit: 32
    t.string   "zip_code",        limit: 32
    t.string   "address_pref",    limit: 32
    t.string   "address_city",    limit: 32
    t.string   "address_area",    limit: 32
    t.string   "address_else",    limit: 64
    t.string   "honorific",       limit: 16
    t.string   "in_charge"
    t.text     "description",     limit: 65535
    t.boolean  "published_flg",                 default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["perent_id"], name: "index_tpd_people_on_perent_id", using: :btree
  end

  create_table "tpd_person_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "code"
    t.string   "access_code"
    t.string   "regist_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parent_id"], name: "index_tpd_person_groups_on_parent_id", using: :btree
  end

  create_table "tpd_person_groups_members", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "person_id"
    t.integer "group_id"
    t.integer "index_order"
    t.index ["group_id"], name: "index_tpd_person_groups_members_on_group_id", using: :btree
    t.index ["person_id"], name: "index_tpd_person_groups_members_on_person_id", using: :btree
  end

  create_table "tpd_person_relations", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "owner_id"
    t.integer "target_id"
    t.index ["owner_id"], name: "index_tpd_person_relations_on_owner_id", using: :btree
    t.index ["target_id"], name: "index_tpd_person_relations_on_target_id", using: :btree
  end

  create_table "tpd_person_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "person_id"
    t.string   "type"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_id"], name: "index_tpd_person_users_on_person_id", using: :btree
  end

  create_table "tpd_upload_files", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "type"
    t.integer  "record_id"
    t.string   "fixed",          limit: 12
    t.string   "file_category"
    t.string   "file_name"
    t.string   "file_type"
    t.string   "save_file_name"
    t.string   "title"
    t.integer  "index_order",                  default: 100
    t.string   "summary"
    t.text     "comment",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
