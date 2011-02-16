# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100322151642) do

  create_table "pages", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "children_count"
    t.integer  "ancestors_count"
    t.integer  "descendants_count"
    t.boolean  "hidden"
    t.text     "name"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_title"
    t.string   "meta_keyword"
    t.string   "meta_desc"
    t.string   "pretty_url"
    t.boolean  "published",         :default => false
    t.datetime "publish_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "firstname"
    t.string   "lastname"
    t.integer  "role"
    t.boolean  "enabled",                                  :default => false
    t.datetime "last_login"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
