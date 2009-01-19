class CreateFacebookIdentities < ActiveRecord::Migration
  def self.up
    create_table :facebook_identities do |t|
      t.integer :facebook_id
      t.integer :user_id
      t.timestamps
    end
    add_index :facebook_identities, :facebook_id
    add_index :facebook_identities, :user_id
  end

  def self.down
    drop_table :facebook_identities
  end
end
