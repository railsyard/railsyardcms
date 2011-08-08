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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110718155100) do

  create_table "associations", :force => true do |t|
    t.integer  "page_id"
    t.integer  "snippet_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "grades", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "pretty_url"
    t.string   "ancestry"
    t.integer  "position"
    t.boolean  "published"
    t.datetime "publish_at"
    t.string   "lang"
    t.boolean  "visible_in_menu"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.text     "script"
    t.string   "div_id"
    t.string   "div_class"
    t.string   "div_style"
    t.boolean  "reserved"
    t.string   "layout_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["ancestry"], :name => "index_pages_on_ancestry"
  add_index "pages", ["pretty_url"], :name => "index_pages_on_pretty_url"
  add_index "pages", ["title"], :name => "index_pages_on_title"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string   "site_name",       :default => "My new RailsYard site"
    t.string   "site_page_title", :default => ""
    t.string   "site_keywords",   :default => ""
    t.string   "site_desc",       :default => ""
    t.string   "default_lang",    :default => "en"
    t.integer  "homepage_id",     :default => 1
    t.string   "site_base_url",   :default => "localhost:3000"
    t.string   "analytics",       :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "theme_name",      :default => "blue"
  end

  create_table "snippets", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "deleted"
    t.boolean  "published"
    t.datetime "publish_at"
    t.string   "div_id"
    t.string   "div_class"
    t.string   "div_style"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "area"
    t.string   "cell_controller"
    t.string   "cell_action"
    t.text     "options"
    t.string   "handler"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lang"
    t.boolean  "enabled"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
