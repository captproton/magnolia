class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :screen_name, :limit => 50
      t.string :crypted_password, :password_salt, :remember_token
      t.integer :login_count
      t.datetime :last_request_at, :last_login_at, :current_login_at, :joined_at
      t.string :last_login_ip, :current_login_ip, :first_login_ip, :limit => 50
      t.boolean :activated, :accepted_service_terms, :default => false
      t.string :activation_code, :limit => 40
    end
    add_index :users, :screen_name
  end

  def self.down
    drop_table :users
  end
end
