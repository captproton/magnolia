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

ActiveRecord::Schema.define(:version => 20090107200544) do

  create_table "facebook_identities", :force => true do |t|
    t.integer  "facebook_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_identities", ["facebook_id"], :name => "index_facebook_identities_on_facebook_id"
  add_index "facebook_identities", ["user_id"], :name => "index_facebook_identities_on_user_id"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",                  :null => false
    t.string  "server_url"
    t.string  "salt",       :default => "", :null => false
  end

  create_table "open_ids", :force => true do |t|
    t.string  "openid_identifier"
    t.integer "user_id"
  end

  add_index "open_ids", ["openid_identifier"], :name => "index_open_ids_on_openid_identifier"
  add_index "open_ids", ["user_id"], :name => "index_open_ids_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "screen_name",           :limit => 50
    t.string   "first_name",            :limit => 50
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "remember_token"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.datetime "joined_at"
    t.string   "last_login_ip",         :limit => 50
    t.string   "current_login_ip",      :limit => 50
    t.string   "first_login_ip",        :limit => 50
    t.boolean  "active",                              :default => false
    t.boolean  "accepted_terms_of_use",               :default => false
    t.string   "activation_code",       :limit => 40
    t.string   "perishable_token",                    :default => "",    :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["screen_name"], :name => "index_users_on_screen_name"

end
