class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :screen_name, :limit => 50
      t.string :email, :crypted_password, :password_salt, :remember_token
      t.integer :login_count
      t.datetime :last_request_at, :last_login_at, :current_login_at, :joined_at
      t.string :last_login_ip, :current_login_ip, :first_login_ip, :limit => 50
      t.boolean :active, :accepted_terms_of_use, :default => false
      t.string :activation_code, :limit => 40
      t.string :perishable_token, :null => false
    end
    add_index :users, :screen_name
    add_index :users, :email
    add_index :users, :perishable_token
  end

  def self.down
    drop_table :users
  end
end
