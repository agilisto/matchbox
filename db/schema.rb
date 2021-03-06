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

ActiveRecord::Schema.define(:version => 20080711072646) do

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "keywords"
    t.string   "ad_copy"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link"
    t.string   "link_text"
  end

  create_table "settings", :force => true do |t|
    t.datetime "last_indexed_at"
    t.datetime "last_refreshed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.string   "identifier"
    t.string   "homepage_url"
    t.string   "feed_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_fetched_at"
  end

  add_index "sites", ["identifier"], :name => "index_sites_on_identifier", :unique => true

  create_table "stories", :force => true do |t|
    t.integer  "site_id",    :limit => 11
    t.string   "uri"
    t.string   "title"
    t.string   "content"
    t.datetime "expired_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
