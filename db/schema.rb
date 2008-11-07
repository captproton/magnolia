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

ActiveRecord::Schema.define(:version => 20081106212028) do

  create_table "users", :force => true do |t|
    t.string   "screen_name",            :limit => 50
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "remember_token"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.datetime "joined_at"
    t.string   "last_login_ip",          :limit => 50
    t.string   "current_login_ip",       :limit => 50
    t.string   "first_login_ip",         :limit => 50
    t.boolean  "activated",                            :default => false
    t.boolean  "accepted_service_terms",               :default => false
    t.string   "activation_code",        :limit => 40
  end

  add_index "users", ["screen_name"], :name => "index_users_on_screen_name"

end
