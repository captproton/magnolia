class CreateAdminAuthenticationProviders < ActiveRecord::Migration
  def self.up
    create_table :authentication_providers do |t|
      t.string  :name, :null => false
      t.string  :type, :null => false, :default => 'AuthenticationProvider'      
      t.string  :label, :logo, :button
      t.text    :description
      t.boolean :active, :null => false, :default => true
      t.integer :display_sequence
      t.timestamps
    end
  end

  def self.down
    drop_table :authentication_providers
  end
end
