class CreateOpenIds < ActiveRecord::Migration
  def self.up
    create_table :open_ids do |t|
      t.column :openid_identifier, :string
      t.column :user_id, :integer
    end
    add_index :open_ids, :user_id
    add_index :open_ids, :openid_identifier
  end

  def self.down
    drop_table :open_ids
  end
end
